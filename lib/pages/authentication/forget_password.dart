import 'package:app/pages/authentication/login.dart';
import 'package:app/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212124)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.forgotPassword ?? 'Forgot Password',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF212124),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: Colors.black.withOpacity(0.08),
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
                        Icons.lock_reset,
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
                  localizations?.resetYourPassword ?? 'Reset Your Password',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212124),
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8.0),

                // Description
                Text(
                  localizations?.resetPasswordDescription ?? 'Enter your email address and we\'ll send you a verification code to reset your password.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40.0),

                // Email Field - matching login style
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
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
                      Icons.email_outlined,
                      color: _isLoading
                          ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    hintText: localizations?.enterEmailAddress ?? 'Enter email address',
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24.0),

                // Send Code Button - matching login style
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
                    onPressed: _isLoading ? null : _sendOTP,
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
                                localizations?.loading ?? 'Loading...',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            localizations?.sendVerificationCode ?? 'Send Verification Code',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24.0),

                // Back to Login
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    localizations?.backToLogin ?? 'Back to Login',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _isLoading
                          ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                          : Theme.of(context).textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w600,
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
    final localizations = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('Please enter your email address');
      return;
    }

    // Basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }

    setState(() => _isLoading = true);

    final authService = ref.read(authenticationServiceProvider);
    final result = await authService.sendOtpChangePassword(
      email: email,
    );

    if (mounted) setState(() => _isLoading = false);

    if (result['success']) {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        _showSuccess(localizations?.verificationCodeSent ?? 'Verification code sent to your email');
        _showPasswordResetDialog(email);
      }
    } else {
      if (mounted) {
        _showError(result['error']);
      }
    }
  }

  void _showPasswordResetDialog(String email) {
    final localizations = AppLocalizations.of(context);
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
              Icon(Icons.verified_user, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(localizations?.resetPassword ?? 'Reset Password'),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizations?.enterVerificationCodeSentTo(email) ?? 'Enter the verification code sent to $email',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: localizations?.enterVerificationCode ?? 'Verification Code',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.pin, color: Theme.of(context).primaryColor),
                      counterText: '',
                      hintText: localizations?.verificationCodeHint ?? '000000',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return localizations?.enterVerificationCode ?? 'Enter verification code';
                      if (value.length != 6) return localizations?.codeMustBe6Digits ?? 'Code must be 6 digits';
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
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
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
                        return localizations?.enterNewPassword ?? 'Enter new password';
                      if (value.length < 8) return localizations?.minimum8Characters ?? 'Minimum 8 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      labelText: localizations?.confirmPassword ?? 'Confirm Password',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon:
                          Icon(Icons.lock_open_sharp, color: Theme.of(context).primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
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
                        return localizations?.passwordsDoNotMatch ?? 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _sendOTP();
                    },
                    icon: Icon(Icons.refresh, size: 18, color: Theme.of(context).primaryColor),
                    label: Text(localizations?.resendCode ?? 'Resend Code',
                        style: TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations?.cancel ?? 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await _resetPassword(
                    email,
                    otpController.text,
                    newPasswordController.text,
                    confirmPasswordController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Text(localizations?.resetPassword ?? 'Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(String email, String otp,
      String newPassword, String confirmPassword) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    navigator.pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
    );

    final authService = ref.read(authenticationServiceProvider);
    final result = await authService.changePassword(
      email: email,
      verificationCode: otp, // Changed from otp to verificationCode
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
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        _showPasswordResetDialog(email);
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
