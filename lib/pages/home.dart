import 'package:app/pages/authentication/login.dart';
import 'package:app/pages/authentication/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
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

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(100), // Adjust radius as needed
                    child: Image.asset(
                      'assets/logo/logo.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.apps,
                          size: 100,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
                  ),

                  // Buttons section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 30.0),
                    child: Column(
                      children: [
                        // Register Button
                        Container(
                          height: 45.0,
                          width: 0.9 * MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register())),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(
                                      0xFFFF9800)), // Better orange shade
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              elevation: MaterialStateProperty.all<double>(
                                  2), // Subtle shadow
                            ),
                            child: Text(
                              AppLocalizations.of(context)?.register ??
                                  'Register',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                letterSpacing: 0.5, // Better text spacing
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 45.0,
                          width: 0.9 * MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login())),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(
                                      0xFFBEACA6)), // Lighter, more refined beige/taupe
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  const Color(
                                      0xFF4A4A4A)), // Dark gray for better readability
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              elevation: MaterialStateProperty.all<double>(
                                  1), // Subtle shadow
                            ),
                            child: Text(
                              AppLocalizations.of(context)
                                      ?.alreadyHaveAccount ??
                                  'Already have an account',
                              style: TextStyle(
                                color: const Color(0xFF4A4A4A), // Dark gray
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                                letterSpacing: 0.5,
                              ),
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
