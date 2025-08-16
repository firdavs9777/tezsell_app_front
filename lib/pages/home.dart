import 'package:app/pages/authentication/login.dart';
import 'package:app/pages/authentication/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/providers/provider_root/locale_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFfdf8e4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfdf8e4),
        elevation: 0,
        actions: [
          // Language switcher in the top right
          PopupMenuButton<String>(
            onSelected: (String languageCode) {
              ref.read(localeProvider.notifier).setLocale(Locale(languageCode));
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    const Text('🇺🇸'),
                    const SizedBox(width: 8),
                    const Text('English'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ru',
                child: Row(
                  children: [
                    const Text('🇷🇺'),
                    const SizedBox(width: 8),
                    const Text('Русский'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'uz',
                child: Row(
                  children: [
                    const Text('🇺🇿'),
                    const SizedBox(width: 8),
                    const Text('O\'zbekcha'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Main heading - localized with fallback
                  Text(
                    AppLocalizations.of(context)?.sellAndBuyProducts ??
                        'Sell and buy any of your products only with us',
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.secondary.withBlue(2),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25.0),

                  // Subtitle - localized with fallback
                  Text(
                    AppLocalizations.of(context)?.usedProductsMarket ??
                        'Used products or second-hand market',
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.secondary.withBlue(2),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),

                  // Logo
                  Image.asset(
                    'assets/logo/logo.png',
                    width: 0.5 * MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if logo doesn't load
                      return Icon(
                        Icons.store,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),

                  // Buttons section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 30.0),
                    child: Column(
                      children: [
                        // Register button - localized
                        Container(
                          height: 45.0,
                          width: 0.9 * MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register())),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)?.register ??
                                  'Register',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Login button - localized
                        Container(
                          height: 45.0,
                          width: 0.9 * MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login())),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF92868a)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)
                                      ?.alreadyHaveAccount ??
                                  'Already have an account',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
