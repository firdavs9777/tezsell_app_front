// Create this file: lib/screens/language_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/locale_provider.dart';
import 'package:app/pages/home.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  // Define supported languages - only Uzbek, Russian, and English
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇺🇸'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский', 'flag': '🇷🇺'},
    {'code': 'uz', 'name': 'Uzbek', 'nativeName': 'O\'zbekcha', 'flag': '🇺🇿'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Header with logo
              Center(
                child: Column(
                  children: [
                    // Add your logo here
                    Image.asset(
                      'assets/logo/logo.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Title
              Center(
                child: Text(
                  'Tilni tanlang', // This will be static for now since user hasn't selected language yet
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ilova uchun afzal ko‘rgan tilingizni tanlang', // This will be static for now
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: 32),

              // Language List
              Expanded(
                child: ListView.builder(
                  itemCount: supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final language = supportedLanguages[index];
                    final isSelected =
                        selectedLocale?.languageCode == language['code'];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref.read(localeProvider.notifier).setLocale(
                                  Locale(language['code']!),
                                );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Flag
                                Text(
                                  language['flag']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 16),

                                // Language names
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        language['nativeName']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                        ),
                                      ),
                                      Text(
                                        language['name']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer
                                                  .withOpacity(0.8)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Selection indicator
                                if (isSelected)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedLocale != null
                      ? () {
                          // Navigate to your main app screen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: Text(
                    'Davom etish', // This will be static for now since user hasn't selected language yet
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
