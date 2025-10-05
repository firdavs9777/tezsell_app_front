import 'package:app/pages/authentication/login.dart';
import 'package:app/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:country_code_picker/country_code_picker.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _countryCode = '+998';
  String _countryName = 'Uzbekistan';
  bool _isLoading = false;

  Color get _primaryColor => Theme.of(context).primaryColor;

  // Get full phone number with country code
  String get fullPhoneNumber => '$_countryCode${_phoneController.text.trim()}';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _primaryColor,
                _primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      size: 60,
                      color: _primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                const Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  'Enter your phone number and we\'ll send you a verification code to reset your password.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 32),

                // Phone Number Field with Country Code Picker
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isLoading ? Colors.grey.shade300 : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: _isLoading ? Colors.grey.shade100 : null,
                  ),
                  child: Row(
                    children: [
                      // Country Code Picker
                      SizedBox(
                        width: 150,
                        child: CountryCodePicker(
                          onChanged: _isLoading
                              ? null
                              : (country) {
                                  setState(() {
                                    _countryCode = country.dialCode!;
                                    _countryName = country.name!;
                                  });
                                },
                          initialSelection: 'UZ',
                          favorite: [
                            '+998',
                            'UZ',
                            '+82',
                            'KR',
                            '+1',
                            'US',
                            '+91',
                            'IN'
                          ],
                          showCountryOnly: false,
                          showFlag: true,
                          showDropDownButton: true,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: _isLoading
                                ? Colors.grey.shade400
                                : Colors.black,
                          ),
                          enabled: !_isLoading,
                          flagWidth: 20,
                        ),
                      ),

                      // Divider
                      Container(
                        height: 50,
                        width: 1,
                        color: _isLoading
                            ? Colors.grey.shade300
                            : Colors.grey.shade400,
                      ),

                      // Phone Number Input
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          enabled: !_isLoading,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: localizations?.enterPhoneNumber ??
                                'Enter phone number',
                            hintStyle: TextStyle(
                              color: _isLoading
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Country and Full Number Preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${localizations?.selectedCountryLabel ?? "Selected:"} $_countryName ($_countryCode)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (_phoneController.text.isNotEmpty)
                      Text(
                        '${localizations?.fullPhoneLabel ?? "Full:"} $fullPhoneNumber',
                        style: TextStyle(
                          fontSize: 12,
                          color: _primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 32),

                // Send Code Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isLoading ? Colors.grey.shade400 : _primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                localizations?.loading ?? 'Loading...',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          )
                        : const Text(
                            'Send Verification Code',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Back to Login
                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                        color:
                            _isLoading ? Colors.grey.shade400 : _primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendOTP() async {
    if (_phoneController.text.trim().isEmpty) {
      _showError('Please enter your phone number');
      return;
    }

    setState(() => _isLoading = true);

    final authService = ref.read(authenticationServiceProvider);
    final result = await authService.sendOtpChangePassword(
      phoneNumber: fullPhoneNumber, // Use full phone number with country code
    );

    if (mounted) setState(() => _isLoading = false);

    if (result['success']) {
      if (mounted) {
        _showSuccess('Verification code sent to your phone');
        _showPasswordResetDialog(fullPhoneNumber);
      }
    } else {
      if (mounted) {
        _showError(result['error']);
      }
    }
  }

  void _showPasswordResetDialog(String phoneNumber) {
    final otpController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.verified_user, color: _primaryColor),
              const SizedBox(width: 8),
              const Text('Reset Password'),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter the verification code sent to $phoneNumber',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Verification Code',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.pin, color: _primaryColor),
                      counterText: '',
                      hintText: '000000',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter verification code';
                      if (value.length != 6) return 'Code must be 6 digits';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock, color: _primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(obscureNew
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setDialogState(() => obscureNew = !obscureNew),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter new password';
                      if (value.length < 8) return 'Minimum 8 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: const OutlineInputBorder(),
                      prefixIcon:
                          Icon(Icons.lock_open_sharp, color: _primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setDialogState(
                            () => obscureConfirm = !obscureConfirm),
                      ),
                    ),
                    validator: (value) {
                      if (value != newPasswordController.text)
                        return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _sendOTP();
                    },
                    icon: Icon(Icons.refresh, size: 18, color: _primaryColor),
                    label: Text('Resend Code',
                        style: TextStyle(color: _primaryColor)),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await _resetPassword(
                    phoneNumber,
                    otpController.text,
                    newPasswordController.text,
                    confirmPasswordController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(String phoneNumber, String otp,
      String newPassword, String confirmPassword) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    navigator.pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: _primaryColor)),
    );

    final authService = ref.read(authenticationServiceProvider);
    final result = await authService.changePassword(
      phoneNumber: phoneNumber,
      otp: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (mounted) navigator.pop();

    if (result['success']) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(result['message'])),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
        }
      }
    } else {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(result['error'])),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        _showPasswordResetDialog(phoneNumber);
      }
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
