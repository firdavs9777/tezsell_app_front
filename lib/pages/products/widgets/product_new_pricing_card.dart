import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/products/widgets/product_new_card.dart';
import 'package:app/utils/currency_utils.dart';
import 'package:app/utils/thousand_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductNewPricingCard extends StatelessWidget {
  const ProductNewPricingCard({
    super.key,
    required this.amountController,
    required this.selectedCurrency,
    required this.availableCurrencies,
    required this.isUploading,
    required this.onCurrencyChanged,
  });

  final TextEditingController amountController;
  final String selectedCurrency;
  final List<String> availableCurrencies;
  final bool isUploading;
  final ValueChanged<String> onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final fillColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);

    return ProductNewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductNewSectionHeader(
            title: localizations?.newProductPrice ?? 'Pricing',
            icon: Icons.attach_money,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: amountController,
                  enabled: !isUploading,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                    ThousandsFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText:
                        '${localizations?.newProductPrice ?? 'Price'} *',
                    hintText: localizations?.newProductPrice ?? 'Enter price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                    filled: true,
                    fillColor: fillColor,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localizations?.priceRequiredMessage ??
                          'Please enter price';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: selectedCurrency,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: localizations?.currency ?? 'Currency',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: fillColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  items: availableCurrencies.map((currency) {
                    final config = CurrencyUtils.getConfig(currency);
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(
                        '${config?.symbol ?? ''} $currency',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: isUploading
                      ? null
                      : (value) {
                          if (value != null) {
                            onCurrencyChanged(value);
                          }
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
