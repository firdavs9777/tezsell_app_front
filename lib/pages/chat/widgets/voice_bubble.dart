import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:flutter/material.dart';

/// Telegram/WhatsApp-style voice message bubble: play/pause button, a
/// waveform with a played-progress fill, and a duration label.
///
/// Task 17: extracted out of `MessageBubble._buildVoiceMessage`. Playback
/// itself (a single shared `AudioPlayer`, stop-previous-on-new-play) is
/// still owned by `ChatRoomScreen` — this widget is stateless and purely
/// driven by [isPlaying] / [playbackPosition] props so there is exactly one
/// active player for the whole chat room regardless of how many voice
/// bubbles are on screen.
class VoiceBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;
  final bool isPlaying;

  /// Current playback position — only meaningful while [isPlaying] is true
  /// for THIS message; ignored otherwise so a paused/stopped bubble always
  /// renders its resting (unplayed) state.
  final Duration playbackPosition;
  final VoidCallback? onTap;

  static const int _barCount = 24;

  const VoiceBubble({
    super.key,
    required this.message,
    required this.isOwnMessage,
    required this.isPlaying,
    this.playbackPosition = Duration.zero,
    this.onTap,
  });

  /// Raw waveform samples (0..100) attached at upload time
  /// (`metadata['waveform']`), or null for messages sent before Task 17 (or
  /// any payload that didn't include one).
  List<int>? get _rawWaveform {
    final raw = message.metadata['waveform'];
    if (raw is List && raw.isNotEmpty) {
      return raw
          .map((e) => (e is num ? e.toInt() : 0).clamp(0, 100))
          .toList();
    }
    return null;
  }

  /// Resamples the raw waveform (or a deterministic placeholder pattern
  /// when there isn't one) to exactly [_barCount] bars, so the row always
  /// renders the same width regardless of how many samples were captured.
  List<int> _resampledBars() {
    final raw = _rawWaveform;
    if (raw == null) {
      return List.generate(_barCount, (i) => (i % 3 + 1) * 25);
    }
    if (raw.length == _barCount) return raw;
    return List.generate(_barCount, (i) {
      final srcIndex = (i * raw.length / _barCount)
          .floor()
          .clamp(0, raw.length - 1);
      return raw[srcIndex];
    });
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final totalSeconds = message.duration ?? 0;
    final hasWaveform = _rawWaveform != null;

    final progress = (isPlaying && totalSeconds > 0)
        ? (playbackPosition.inMilliseconds / (totalSeconds * 1000)).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    // Falls back to the generic "Voice message" label only when there's
    // neither a waveform nor a known duration to show — otherwise show the
    // elapsed time while playing, or the total duration at rest.
    final label = (!hasWaveform && totalSeconds == 0)
        ? l.chatVoiceMessage
        : _formatDuration(isPlaying ? playbackPosition.inSeconds : totalSeconds);

    final bars = _resampledBars();

    final activeColor = isOwnMessage
        ? Colors.white
        : Theme.of(context).colorScheme.primary;
    final inactiveColor = isOwnMessage
        ? Colors.white.withOpacity(0.35)
        : Theme.of(context).colorScheme.primary.withOpacity(0.3);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isOwnMessage
                    ? Colors.white.withOpacity(0.25)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isOwnMessage
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(bars.length, (index) {
                      final height = 4.0 + (bars[index] / 100) * 20;
                      final playedFraction = index / bars.length;
                      final played = progress > 0 && playedFraction <= progress;
                      return Container(
                        width: 3,
                        height: height,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: played ? activeColor : inactiveColor,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isOwnMessage
                          ? Colors.white.withOpacity(0.8)
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.mic,
              color: isOwnMessage
                  ? Colors.white.withOpacity(0.7)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
