import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class BecomeAgentPage extends ConsumerStatefulWidget {
  const BecomeAgentPage({super.key});

  @override
  ConsumerState<BecomeAgentPage> createState() => _BecomeAgentPageState();
}

class _BecomeAgentPageState extends ConsumerState<BecomeAgentPage> {
  final _formKey = GlobalKey<FormState>();
  final _agencyNameController = TextEditingController();
  final _licenceNumberController = TextEditingController();
  final _yearsExperienceController = TextEditingController();

  String _selectedSpecialization = 'Residential';
  bool _isSubmitting = false;
  String? _userToken;

  final List<String> _specializations = [
    'Residential',
    'Commercial',
    'Luxury',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserToken();
  }

  @override
  void dispose() {
    _agencyNameController.dispose();
    _licenceNumberController.dispose();
    _yearsExperienceController.dispose();
    super.dispose();
  }

  Future<void> _loadUserToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _userToken = prefs.getString('token');
        });
      }
    } catch (e) {
      AppLogger.error('Error loading token: $e');
    }
  }

  Future<void> _submitApplication() async {
    if (_userToken == null) {
      final l10n = AppLocalizations.of(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.authLoginRequired ?? 'Please login to continue'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: l10n?.authLogin ?? 'Login',
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
          ),
        );
      }
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await ref.read(realEstateServiceProvider).becomeAgent(
            agencyName: _agencyNameController.text.trim(),
            licenceNumber: _licenceNumberController.text.trim(),
            yearsExperience: int.tryParse(_yearsExperienceController.text) ?? 0,
            specialization: _selectedSpecialization,
            token: _userToken!,
          );

      if (mounted) {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop(true);

        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.agentApplicationSubmitted ??
                  'Application submitted successfully! We will review it soon.',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        AppErrorHandler.showError(context, error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.becomeAgent ?? 'Become an Agent'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.real_estate_agent,
                      color: theme.primaryColor,
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n?.becomeAgentTitle ??
                                'Join as a Real Estate Agent',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n?.becomeAgentSubtitle ??
                                'List properties and help clients find their dream homes',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Benefits
              Text(
                l10n?.agentBenefits ?? 'Benefits:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _buildBenefitItem(
                Icons.verified,
                l10n?.agentBenefitVerified ??
                    'Verified agent badge',
                Colors.blue,
              ),
              _buildBenefitItem(
                Icons.analytics,
                l10n?.agentBenefitAnalytics ??
                    'Access to analytics and insights',
                Colors.green,
              ),
              _buildBenefitItem(
                Icons.people,
                l10n?.agentBenefitClients ??
                    'Direct contact with potential clients',
                Colors.orange,
              ),
              _buildBenefitItem(
                Icons.star,
                l10n?.agentBenefitReputation ??
                    'Build your professional reputation',
                Colors.purple,
              ),
              const SizedBox(height: 32),

              // Form Fields
              Text(
                l10n?.agentApplicationForm ?? 'Application Form',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _agencyNameController,
                decoration: InputDecoration(
                  labelText: l10n?.agentAgencyName ?? 'Agency Name *',
                  hintText: l10n?.agentAgencyNameHint ??
                      'Enter your real estate agency name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n?.agentAgencyNameRequired ??
                        'Agency name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _licenceNumberController,
                decoration: InputDecoration(
                  labelText: l10n?.agentLicenceNumber ?? 'License Number *',
                  hintText: l10n?.agentLicenceNumberHint ??
                      'Enter your real estate license number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n?.agentLicenceNumberRequired ??
                        'License number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _yearsExperienceController,
                decoration: InputDecoration(
                  labelText: l10n?.agentYearsExperience ?? 'Years of Experience *',
                  hintText: l10n?.agentYearsExperienceHint ??
                      'Enter number of years',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n?.agentYearsExperienceRequired ??
                        'Years of experience is required';
                  }
                  final years = int.tryParse(value);
                  if (years == null || years < 0) {
                    return l10n?.agentYearsExperienceInvalid ??
                        'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedSpecialization,
                decoration: InputDecoration(
                  labelText: l10n?.agentSpecialization ?? 'Specialization *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _specializations.map((spec) {
                  return DropdownMenuItem(
                    value: spec,
                    child: Text(spec),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecialization = value!;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n?.agentApplicationNote ??
                            'Your application will be reviewed by our team. You will be notified once your application is approved.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                          ),
                        )
                      : Text(
                          l10n?.agentSubmitApplication ??
                              'Submit Application',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

