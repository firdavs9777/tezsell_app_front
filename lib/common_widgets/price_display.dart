import 'package:flutter/material.dart';
import 'package:app/utils/currency_utils.dart';

/// A widget that displays a formatted price with the appropriate currency symbol
class PriceDisplay extends StatelessWidget {
  final num price;
  final String currencyCode;
  final TextStyle? style;
  final bool showCurrencyCode;

  const PriceDisplay({
    super.key,
    required this.price,
    required this.currencyCode,
    this.style,
    this.showCurrencyCode = false,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = CurrencyUtils.formatPrice(price, currency: currencyCode);
    final displayText = showCurrencyCode ? '$formattedPrice ($currencyCode)' : formattedPrice;

    return Text(
      displayText,
      style: style,
    );
  }
}

/// A widget that displays a country flag emoji
class CountryFlag extends StatelessWidget {
  final String countryCode;
  final double size;

  const CountryFlag({
    super.key,
    required this.countryCode,
    this.size = 24,
  });

  String get flagEmoji {
    if (countryCode.length != 2) return '';
    return countryCode.toUpperCase().codeUnits
        .map((c) => String.fromCharCode(c + 127397))
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      flagEmoji,
      style: TextStyle(fontSize: size),
    );
  }
}

/// A widget that displays price with optional discount/original price
class PriceWithDiscount extends StatelessWidget {
  final num currentPrice;
  final num? originalPrice;
  final String currencyCode;
  final TextStyle? priceStyle;
  final TextStyle? originalPriceStyle;

  const PriceWithDiscount({
    super.key,
    required this.currentPrice,
    this.originalPrice,
    required this.currencyCode,
    this.priceStyle,
    this.originalPriceStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultPriceStyle = priceStyle ?? theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
    );
    final defaultOriginalStyle = originalPriceStyle ?? theme.textTheme.bodySmall?.copyWith(
      decoration: TextDecoration.lineThrough,
      color: theme.colorScheme.onSurfaceVariant,
    );

    if (originalPrice != null && originalPrice! > currentPrice) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PriceDisplay(
            price: currentPrice,
            currencyCode: currencyCode,
            style: defaultPriceStyle,
          ),
          const SizedBox(width: 8),
          PriceDisplay(
            price: originalPrice!,
            currencyCode: currencyCode,
            style: defaultOriginalStyle,
          ),
        ],
      );
    }

    return PriceDisplay(
      price: currentPrice,
      currencyCode: currencyCode,
      style: defaultPriceStyle,
    );
  }
}
