import 'package:app/pages/authentication/password_set.dart';
import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/service/mobile_authentication.dart';
import 'dart:async';

class MobileAuthentication extends StatefulWidget {
  final String regionName;
  final String districtId;
  final String districtName;
  const MobileAuthentication(
      {super.key,
      required this.regionName,
      required this.districtId,
      required this.districtName});

  @override
  State<MobileAuthentication> createState() => _MobileAuthenticationState();
}

class _MobileAuthenticationState extends State<MobileAuthentication> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  bool columnVisible = false;
  bool isSendingCode = false;
  bool isVerifyingCode = false;
  bool isResendingCode = false;
  String? _verifiedEmail; // Store verified email
  Timer? _timer;
  int _timeLeft = 300; // 5 minutes in seconds

  // Verifying the code and navigating to the next step if valid
  Future<void> _verifyCode() async {
    final email = _emailController.text.trim();
    final code = _verificationCodeController.text.trim();

    final localizations = AppLocalizations.of(context);
    
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations?.enterVerificationCode ?? 'Please enter the verification code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Verification code must be 6 digits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isVerifyingCode = true;
    });

    final result = await verifyEmailCode(email, code);

    setState(() {
      isVerifyingCode = false;
    });

    if (result['success'] == true && result['verified'] == true) {
      _timer?.cancel();
      // Store verified email
      _verifiedEmail = email;
      // Verification successful, proceed to password setup
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordReset(
                regionName: widget.regionName,
                districtId: widget.districtId,
                districtName: widget.districtName,
                email: email,
                verificationCode: code), // Pass verification code to registration
          ),
        );
      }
    } else {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? (localizations?.invalidVerificationCode ?? 'Invalid or expired verification code')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendCode() async {
    final localizations = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isSendingCode = true;
    });

    final result = await sendEmailVerificationCode(email);

    setState(() {
      isSendingCode = false;
    });

    if (result['success']) {
      setState(() {
        columnVisible = true;
        _timeLeft = 300; // Reset timer
      });
      _startTimer();
      
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? (localizations?.verificationCodeSent ?? 'Verification code sent to your email')),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? (localizations?.failedToSendCode ?? 'Failed to send verification code')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      isResendingCode = true;
    });

    final result = await sendEmailVerificationCode(email);

    setState(() {
      isResendingCode = false;
    });

    if (result['success']) {
      setState(() {
        _timeLeft = 300; // Reset timer
      });
      _startTimer();
      
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? (localizations?.verificationCodeResent ?? 'Verification code resent')),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? (localizations?.failedToResendCode ?? 'Failed to resend code')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          columnVisible = false;
        });
      }
    });
  }

  String get formattedTime {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations?.emailVerification ?? 'Email Verification'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF212124),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                        Icons.email_outlined,
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
                localizations?.pleaseEnterYourEmailAddress ?? 'Please enter your email address',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40.0),

              // Email input - matching login style
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isSendingCode && !isVerifyingCode,
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
                      color: (isSendingCode || isVerifyingCode)
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

              // Continue button - matching login style
              Container(
                width: double.infinity,
                height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: (isSendingCode || isVerifyingCode)
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
                        onPressed: isSendingCode ? null : _sendCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (isSendingCode || isVerifyingCode)
                              ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.2)
                              : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSendingCode
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
                          localizations?.continueButton ?? 'Continue',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32.0),

              // Verification code section (shown after code is sent)
              if (columnVisible)
                Column(
                  children: [
                    // Verification code input - matching login style
                    TextField(
                      controller: _verificationCodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      enabled: !isVerifyingCode,
                      textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                      decoration: InputDecoration(
                        labelText: localizations?.enterVerificationCode ?? 'Verification Code',
                        hintText: '000000',
                        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
                          letterSpacing: 8,
                        ),
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
                          Icons.pin_outlined,
                          color: isVerifyingCode
                              ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                              : Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: isResendingCode ? null : _resendCode,
                          icon: Icon(
                            Icons.refresh,
                            size: 18,
                            color: isResendingCode
                                ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                                : Theme.of(context).primaryColor,
                          ),
                          label: Text(
                            isResendingCode 
                                ? (localizations?.sending ?? 'Sending...')
                                : (localizations?.resendCode ?? 'Resend Code'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isResendingCode
                                  ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                                  : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Expires: $formattedTime',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Verify button - matching login style
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isVerifyingCode
                            ? []
                            : [
                                BoxShadow(
                                  color: const Color(0xFFFF6F0F).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: ElevatedButton(
                        onPressed: isVerifyingCode ? null : _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isVerifyingCode
                              ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.2)
                              : Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isVerifyingCode
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
                                  const Text(
                                    'Verifying...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                localizations?.verifyAndContinue ?? 'Verify and Continue',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
