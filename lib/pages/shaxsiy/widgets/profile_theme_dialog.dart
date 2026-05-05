import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String getCurrentThemeName(WidgetRef ref, AppLocalizations? localizations) {
  final currentTheme = ref.read(themeProvider);
  switch (currentTheme) {
    case ThemeMode.light:
      return localizations?.light_theme ?? 'Light';
    case ThemeMode.dark:
      return localizations?.dark_theme ?? 'Dark';
    case ThemeMode.system:
      return localizations?.system_theme ?? 'System Default';
  }
}

void showProfileThemeDialog(BuildContext context, WidgetRef ref) {
  final localizations = AppLocalizations.of(context);
  final currentTheme = ref.read(themeProvider);
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
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
              localizations?.select_theme ?? 'Select Theme',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            _ThemeOption(
              label: localizations?.light_theme ?? 'Light',
              icon: Icons.light_mode,
              themeMode: ThemeMode.light,
              isSelected: currentTheme == ThemeMode.light,
            ),
            _ThemeOption(
              label: localizations?.dark_theme ?? 'Dark',
              icon: Icons.dark_mode,
              themeMode: ThemeMode.dark,
              isSelected: currentTheme == ThemeMode.dark,
            ),
            _ThemeOption(
              label: localizations?.system_theme ?? 'System Default',
              icon: Icons.settings_brightness,
              themeMode: ThemeMode.system,
              isSelected: currentTheme == ThemeMode.system,
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

class _ThemeOption extends ConsumerWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.themeMode,
    required this.isSelected,
  });

  final String label;
  final IconData icon;
  final ThemeMode themeMode;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        ref.read(themeProvider.notifier).setTheme(themeMode);
        Navigator.pop(context);
        _showThemeChangedSnackBar(context, label);
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: colorScheme.onSurfaceVariant, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
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

  void _showThemeChangedSnackBar(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text('Theme changed to $label')),
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
