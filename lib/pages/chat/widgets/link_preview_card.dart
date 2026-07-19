import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// 🔥 NEW: Task 18 — parsed `og:title`/`og:image` (+ a `<title>` fallback)
/// for a single URL, or `null` cached to mark "fetched, nothing usable" so a
/// failed/empty page isn't re-fetched every time the bubble rebuilds.
class _LinkPreviewData {
  final String? title;
  final String? imageUrl;
  const _LinkPreviewData({this.title, this.imageUrl});
}

/// Detects the first http(s) URL in [text], or null if there isn't one.
/// Shared by [MessageBubble] to decide whether to render a [LinkPreviewCard]
/// at all.
String? extractFirstUrl(String text) {
  final match = RegExp(r'https?://[^\s<>"]+').firstMatch(text);
  return match?.group(0);
}

/// Compact "link preview" card rendered under a text bubble when its content
/// contains a URL — title + domain + optional thumbnail, fetched client-side
/// (no backend involvement) with a short timeout and a small in-memory LRU
/// cache so re-rendering the same message (list rebuilds, scrolling) doesn't
/// re-fetch. Any failure (timeout, non-200, no usable og tags) fails silently
/// — the card simply doesn't render, never an error state.
class LinkPreviewCard extends StatefulWidget {
  final String url;

  const LinkPreviewCard({super.key, required this.url});

  @override
  State<LinkPreviewCard> createState() => _LinkPreviewCardState();
}

class _LinkPreviewCardState extends State<LinkPreviewCard> {
  // 🔥 In-memory LRU cache keyed by URL, capped at ~50 entries — shared
  // across all card instances for the app's lifetime (cleared on restart).
  static final Map<String, _LinkPreviewData?> _cache = {};
  static final List<String> _cacheOrder = [];
  static const int _maxCacheSize = 50;

  _LinkPreviewData? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant LinkPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loading = true;
      _data = null;
      _load();
    }
  }

  Future<void> _load() async {
    if (_cache.containsKey(widget.url)) {
      final cached = _cache[widget.url];
      if (mounted) setState(() { _data = cached; _loading = false; });
      return;
    }

    _LinkPreviewData? result;
    try {
      final uri = Uri.tryParse(widget.url);
      if (uri != null) {
        final response = await http
            .get(uri, headers: const {'User-Agent': 'Mozilla/5.0 (compatible; SabziMarketBot/1.0)'})
            .timeout(const Duration(seconds: 3));
        if (response.statusCode == 200) {
          final body = response.body;
          final title = _extractMeta(body, 'og:title') ?? _extractTitle(body);
          final image = _extractMeta(body, 'og:image');
          if (title != null || image != null) {
            result = _LinkPreviewData(title: title, imageUrl: image);
          }
        }
      }
    } catch (_) {
      // Silent fail — no preview, no error surfaced to the user.
      result = null;
    }

    _cacheResult(widget.url, result);
    if (mounted) setState(() { _data = result; _loading = false; });
  }

  static void _cacheResult(String url, _LinkPreviewData? data) {
    if (!_cache.containsKey(url)) {
      _cacheOrder.add(url);
      if (_cacheOrder.length > _maxCacheSize) {
        final oldest = _cacheOrder.removeAt(0);
        _cache.remove(oldest);
      }
    }
    _cache[url] = data;
  }

  static String? _extractMeta(String html, String property) {
    // og tags appear in either attribute order (`property` before/after
    // `content`) across real-world pages — try both.
    final patterns = [
      '<meta[^>]+property=["\']$property["\'][^>]+content=["\']([^"\']*)["\']',
      '<meta[^>]+content=["\']([^"\']*)["\'][^>]+property=["\']$property["\']',
    ];
    for (final pattern in patterns) {
      final match = RegExp(pattern, caseSensitive: false, dotAll: true).firstMatch(html);
      if (match != null) {
        final value = match.group(1);
        if (value != null && value.isNotEmpty) return _unescape(value);
      }
    }
    return null;
  }

  static String? _extractTitle(String html) {
    final match = RegExp(r'<title[^>]*>([^<]*)</title>', caseSensitive: false)
        .firstMatch(html);
    final value = match?.group(1)?.trim();
    return (value != null && value.isNotEmpty) ? _unescape(value) : null;
  }

  static String _unescape(String s) {
    return s
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }

  Future<void> _openUrl() async {
    final uri = Uri.tryParse(widget.url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Silent — no snackbar plumbing needed for a best-effort preview tap.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _data == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final data = _data!;
    final domain = Uri.tryParse(widget.url)?.host ?? widget.url;
    final hasImage = data.imageUrl != null && data.imageUrl!.isNotEmpty;

    final card = Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(maxWidth: 260),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasImage) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                data.imageUrl!,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (data.title != null)
                  Text(
                    data.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Text(
                  domain,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // url_launcher is already a dependency, so the card is tappable — opens
    // the link in the system browser.
    return GestureDetector(onTap: _openUrl, child: card);
  }
}
