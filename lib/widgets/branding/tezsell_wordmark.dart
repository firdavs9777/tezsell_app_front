import 'package:flutter/material.dart';

/// TezSell brand wordmark — replaces tiny stretched logo PNGs on splash,
/// welcome, login, and registration entry points.
///
/// "Tez" (Uzbek "fast") rendered in the primary brand color with a soft
/// gradient sheen; "Sell" rendered in the surface-foreground for legibility.
/// A small storefront-pin glyph anchors it as a marketplace mark.
class TezSellWordmark extends StatelessWidget {
  const TezSellWordmark({
    super.key,
    this.size = TezSellWordmarkSize.large,
    this.showTagline = false,
    this.tagline,
  });

  final TezSellWordmarkSize size;
  final bool showTagline;
  final String? tagline;

  double get _fontSize => switch (size) {
        TezSellWordmarkSize.small => 28,
        TezSellWordmarkSize.medium => 44,
        TezSellWordmarkSize.large => 64,
      };

  double get _glyphSize => _fontSize * 0.85;

  double get _taglineSize => switch (size) {
        TezSellWordmarkSize.small => 11,
        TezSellWordmarkSize.medium => 13,
        TezSellWordmarkSize.large => 15,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primaryGradient = LinearGradient(
      colors: [
        colorScheme.primary,
        Color.lerp(colorScheme.primary, colorScheme.tertiary, 0.6) ??
            colorScheme.primary,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Storefront-pin glyph anchored to the wordmark
            ShaderMask(
              shaderCallback: (bounds) =>
                  primaryGradient.createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: Icon(
                Icons.storefront_rounded,
                size: _glyphSize,
                color: Colors.white,
              ),
            ),
            SizedBox(width: _fontSize * 0.18),
            // "Tez" — primary gradient
            ShaderMask(
              shaderCallback: (bounds) =>
                  primaryGradient.createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: Text(
                'Tez',
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -_fontSize * 0.04,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
            // "Sell" — onSurface
            Text(
              'Sell',
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.w900,
                letterSpacing: -_fontSize * 0.04,
                color: isDark
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.92),
                height: 1.0,
              ),
            ),
            // Brand accent dot
            Padding(
              padding: EdgeInsets.only(left: _fontSize * 0.04),
              child: Container(
                width: _fontSize * 0.12,
                height: _fontSize * 0.12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          SizedBox(height: _fontSize * 0.18),
          Text(
            tagline ?? 'Your neighborhood marketplace',
            style: TextStyle(
              fontSize: _taglineSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }
}

enum TezSellWordmarkSize { small, medium, large }
