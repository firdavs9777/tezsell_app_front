import 'dart:io';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/store/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/profile-terms/terms_and_conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordReset extends StatefulWidget {
  final String regionName;
  final String districtName;
  final String districtId;
  final String email;
  final String? verificationCode; // Verification code from email verification step

  const PasswordReset({
    super.key,
    required this.regionName,
    required this.districtName,
    required this.districtId,
    required this.email,
    this.verificationCode,
  });

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  bool _isObscure = true;
  bool _isObscure_secondary = true;
  bool _isLoading = false;
  bool _termsAccepted = false;
  late AuthenticationService authService;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // Password validation helper
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.passwordRequired ??
          'Parol kiritish majburiy';
    }
    if (value.length < 8) {
      return AppLocalizations.of(context)?.passwordTooShort ??
          'Parol kamida 8 belgidan iborat bo\'lishi kerak';
    }
    // Check for at least one letter and one number
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
      return AppLocalizations.of(context)?.passwordRequirements ??
          'Parol harf va raqamdan iborat bo\'lishi kerak';
    }
    return null;
  }

  // Username validation helper
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.usernameRequired ??
          'Foydalanuvchi ismi majburiy';
    }
    if (value.length < 3) {
      return AppLocalizations.of(context)?.usernameTooShort ??
          'Foydalanuvchi ismi kamida 3 belgidan iborat bo\'lishi kerak';
    }
    return null;
  }

  // Function to pick a single image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImages.clear();
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  // Show error dialog with detailed message
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.error ?? 'Xatolik'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)?.ok ?? 'OK'),
          ),
        ],
      ),
    );
  }

  // Handle registration
  Future<void> _handleRegistration() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check terms acceptance
    if (!_termsAccepted) {
      _showErrorDialog(
        AppLocalizations.of(context)?.acceptTermsRequired ??
            'You must accept the Terms and Conditions to continue',
      );
      return;
    }

    String userName = _userNameController.text.trim();
    String password = _passwordController.text;
    String passwordConfirmation = _passwordConfirmationController.text;

    // Check password match
    if (password != passwordConfirmation) {
      _showErrorDialog(AppLocalizations.of(context)?.passwordsDoNotMatch ??
          'Parollar mos kelmayapti');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      // Check if verification code is provided (required for registration)
      if (widget.verificationCode == null || widget.verificationCode!.isEmpty) {
        _showErrorDialog('Verification code is required. Please verify your email first.');
        return;
      }

      // Pass the selected images to the registration service
      final result = await authService.register(
        widget.email,
        password,
        userName,
        widget.regionName,
        widget.districtName,
        widget.districtId,
        _selectedImages.isNotEmpty ? _selectedImages[0] : null,
        null, // phone_number is optional
        widget.verificationCode!, // Required verification code
      );

      if (!mounted) return;

      if (result != null) {
        // Store terms acceptance
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('terms_accepted', true);
        await prefs.setString('terms_accepted_date', DateTime.now().toIso8601String());
        
        // Success
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const TabsScreen()),
        );
      } else {
        // Registration failed - show generic error
        _showErrorDialog(AppLocalizations.of(context)?.registrationError ??
            'Ro\'yxatdan o\'tishda xatolik yuz berdi. Qaytadan urinib ko\'ring.');
      }
    } catch (e) {

      if (!mounted) return;

      // Parse error message
      String errorMessage = AppLocalizations.of(context)?.registrationError ??
          'Ro\'yxatdan o\'tishda xatolik yuz berdi';

      String errorString = e.toString().toLowerCase();

      // Check for specific error patterns from backend
      if (errorString.contains('email already exists') ||
          errorString.contains('user with this email')) {
        errorMessage = 'Bu email allaqachon ro\'yxatdan o\'tgan';
      } else if (errorString.contains('username already exists') ||
          errorString.contains('user with that username')) {
        errorMessage = AppLocalizations.of(context)?.usernameExists ??
            'Bu foydalanuvchi ismi allaqachon mavjud';
      } else if (errorString.contains('network') ||
          errorString.contains('connection') ||
          errorString.contains('socket')) {
        errorMessage = AppLocalizations.of(context)?.networkError ??
            'Internetga ulanishda xatolik. Iltimos, ulanishni tekshiring';
      } else if (errorString.contains('password')) {
        // Show the actual password error from backend
        errorMessage = e.toString();
      } else if (e.toString().length > 10 &&
          !e.toString().startsWith('Exception:')) {
        // If the error message is detailed and doesn't start with "Exception:", show it directly
        errorMessage = e.toString();
      }

      _showErrorDialog(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    authService = AuthenticationService(authStatesProvider);
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.passwordVerification ??
              'Password Verification',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onBackground,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40.0),

              // Logo with circular background matching login
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo/logo.png',
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person_add,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32.0),

              // Title
              Text(
                AppLocalizations.of(context)?.completeRegistrationPrompt ??
                    'Complete Your Registration',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40.0),

              // Username field with validation - matching login style
              TextFormField(
                controller: _userNameController,
                validator: _validateUsername,
                enabled: !_isLoading,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: _isLoading
                        ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                        : Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  labelText: AppLocalizations.of(context)?.username ??
                      'Username',
                  hintText: AppLocalizations.of(context)?.usernameHint ??
                      'Enter username',
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Password field with validation - matching login style
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                validator: _validatePassword,
                enabled: !_isLoading,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: _isLoading
                        ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                        : Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: _isLoading
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      size: 22,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                  ),
                  hintText: AppLocalizations.of(context)?.enterPassword ??
                      'Password',
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w400,
                  ),
                  helperText: AppLocalizations.of(context)?.passwordHelp ??
                      'Minimum 8 characters, letters and numbers',
                  helperMaxLines: 2,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Password confirmation field - matching login style
              TextFormField(
                controller: _passwordConfirmationController,
                obscureText: _isObscure_secondary,
                enabled: !_isLoading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)
                            ?.confirmPasswordRequired ??
                        'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return AppLocalizations.of(context)
                            ?.passwordsDoNotMatch ??
                        'Passwords do not match';
                  }
                  return null;
                },
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: _isLoading
                        ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                        : Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure_secondary
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: _isLoading
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      size: 22,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _isObscure_secondary = !_isObscure_secondary;
                            });
                          },
                  ),
                  hintText: AppLocalizations.of(context)?.confirmPassword ??
                      'Confirm Password',
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Profile image picker - matching login style
              TextFormField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.image_outlined,
                    color: _isLoading
                        ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                        : Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  hintText: AppLocalizations.of(context)?.profileImage ??
                      'Profile Image (Optional)',
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
                readOnly: true,
                onTap: _isLoading ? null : _pickImage,
              ),

              if (_selectedImages.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.imageInstructions ??
                          'Tap above to select profile image (optional)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

              if (_selectedImages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImages[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24.0),

              // Terms and Conditions acceptance
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Checkbox(
                      value: _termsAccepted,
                      activeColor: Theme.of(context).primaryColor,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _termsAccepted = value ?? false;
                            });
                          },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _termsAccepted = !_termsAccepted;
                              });
                            },
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)
                                      ?.iAgreeToTerms ??
                                  'I agree to the ',
                            ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                        ?.termsAndConditions ??
                                    'Terms and Conditions',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            TextSpan(
                              text: AppLocalizations.of(context)
                                      ?.zeroToleranceStatement ??
                                  ' and understand that there is zero tolerance for objectionable content or abusive users.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionsPage(),
                            ),
                          );
                        },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.viewTerms ??
                        'View Terms and Conditions',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFFF6F0F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Submit button with loading state - matching login style
              Container(
                width: double.infinity,
                height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _isLoading
                        ? []
                        : Theme.of(context).brightness == Brightness.dark
                            ? []
                            : [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading
                          ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.2)
                          : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                      disabledBackgroundColor: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)?.loading ??
                                  'Loading...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          AppLocalizations.of(context)?.finish ?? 'Finish',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
