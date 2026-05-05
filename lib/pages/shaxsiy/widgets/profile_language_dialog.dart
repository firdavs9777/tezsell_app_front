import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<Map<String, String>> _supportedLanguages = [
  {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇺🇸'},
  {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский', 'flag': '🇷🇺'},
  {'code': 'uz', 'name': 'Uzbek', 'nativeName': "O'zbekcha", 'flag': '🇺🇿'},
];

String getCurrentLanguageName(WidgetRef ref) {
  final currentLocale = ref.read(localeProvider);
  if (currentLocale == null) return 'English';
  final language = _supportedLanguages.firstWhere(
    (lang) => lang['code'] == currentLocale.languageCode,
    orElse: () => _supportedLanguages[0],
  );
  return language['nativeName']!;
}

void showProfileLanguageDialog(BuildContext context, WidgetRef ref) {
  final localizations = AppLocalizations.of(context);
  final currentLocale = ref.read(localeProvider);
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              localizations?.selectLanguage ?? 'Select Language',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            ..._supportedLanguages.map(
              (language) => _LanguageOption(
                language: language['nativeName']!,
                code: language['code']!,
                flag: language['flag']!,
                isSelected:
                    currentLocale?.languageCode == language['code'],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

class _LanguageOption extends ConsumerWidget {
  const _LanguageOption({
    required this.language,
    required this.code,
    required this.flag,
    required this.isSelected,
  });

  final String language;
  final String code;
  final String flag;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(Locale(code));
        Navigator.pop(context);
        _showLanguageChangedSnackBar(context, language);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border:
              isSelected ? Border.all(color: colorScheme.primary) : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                language,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                    ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageChangedSnackBar(BuildContext context, String language) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text('Language changed to $language')),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
