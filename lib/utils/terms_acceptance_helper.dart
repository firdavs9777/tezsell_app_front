import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/pages/shaxsiy/profile-terms/terms_and_conditions.dart';
import 'package:app/l10n/app_localizations.dart';

class TermsAcceptanceHelper {
  static const String _termsAcceptedKey = 'terms_accepted';
  static const String _termsAcceptedDateKey = 'terms_accepted_date';

  /// Check if user has accepted terms
  static Future<bool> hasAcceptedTerms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_termsAcceptedKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Mark terms as accepted
  static Future<void> acceptTerms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_termsAcceptedKey, true);
      await prefs.setString(_termsAcceptedDateKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Handle error silently or log it
    }
  }

  /// Show terms acceptance dialog that cannot be dismissed without accepting
  static Future<bool> showTermsAcceptanceDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Cannot dismiss by tapping outside
      builder: (BuildContext context) {
        bool termsAccepted = false;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                localizations?.customer_terms ?? 'Terms and Conditions',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations?.acceptTermsRequired ??
                          'You must accept the Terms and Conditions to continue using this app.',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations?.zeroToleranceStatement ??
                          'By accepting, you understand that there is zero tolerance for objectionable content or abusive users.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              termsAccepted = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                termsAccepted = !termsAccepted;
                              });
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                children: [
                                  TextSpan(
                                    text: localizations?.iAgreeToTerms ?? 'I agree to the ',
                                  ),
                                  TextSpan(
                                    text: localizations?.termsAndConditions ?? 'Terms and Conditions',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: localizations?.zeroToleranceStatement ??
                                        ' and understand that there is zero tolerance for objectionable content or abusive users.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsAndConditionsPage(),
                          ),
                        );
                      },
                      child: Text(
                        localizations?.viewTerms ?? 'View Terms and Conditions',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: termsAccepted
                      ? () async {
                          await acceptTerms();
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        }
                      : null,
                  child: Text(
                    localizations?.finish ?? 'Accept',
                    style: TextStyle(
                      color: termsAccepted ? Colors.blue : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ) ?? false;
  }

  /// Show terms acceptance required dialog before content creation
  static Future<bool> showTermsRequiredForContentDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations?.acceptTermsRequired ?? 'Terms Acceptance Required',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You must accept the Terms and Conditions before creating content.',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Text(
                localizations?.zeroToleranceStatement ??
                    'The Terms clearly state that there is zero tolerance for objectionable content or abusive users.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(localizations?.cancel ?? 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Close dialog and navigate to terms page
                Navigator.of(context).pop(false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAcceptanceScreen(),
                  ),
                );
              },
              child: Text(localizations?.viewTerms ?? 'View Terms'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  /// Check and handle terms acceptance - returns true if accepted, false otherwise
  static Future<bool> checkAndHandleTermsAcceptance(BuildContext context) async {
    final hasAccepted = await hasAcceptedTerms();
    
    if (!hasAccepted) {
      final accepted = await showTermsAcceptanceDialog(context);
      return accepted;
    }
    
    return true;
  }
}

/// Full-screen terms acceptance screen
class TermsAcceptanceScreen extends StatefulWidget {
  const TermsAcceptanceScreen({super.key});

  @override
  State<TermsAcceptanceScreen> createState() => _TermsAcceptanceScreenState();
}

class _TermsAcceptanceScreenState extends State<TermsAcceptanceScreen> {
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations?.customer_terms ?? 'Terms and Conditions',
        ),
        automaticallyImplyLeading: false, // Prevent back button
      ),
      body: Column(
        children: [
          Expanded(
            child: const TermsAndConditionsPage(),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _termsAccepted = !_termsAccepted;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurface,
                              ),
                              children: [
                                TextSpan(
                                  text: localizations?.iAgreeToTerms ?? 'I agree to the ',
                                ),
                                TextSpan(
                                  text: localizations?.termsAndConditions ?? 'Terms and Conditions',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: localizations?.zeroToleranceStatement ??
                                      ' and understand that there is zero tolerance for objectionable content or abusive users.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _termsAccepted
                          ? () async {
                              await TermsAcceptanceHelper.acceptTerms();
                              if (context.mounted) {
                                Navigator.of(context).pop(true);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        localizations?.finish ?? 'Accept and Continue',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

