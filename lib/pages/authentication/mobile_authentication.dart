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

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the verification code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code must be 6 digits'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Invalid or expired verification code'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Verification code sent to your email'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to send verification code'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Verification code resent'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to resend code'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Please enter your email address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // Email input
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'Enter email address',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: isSendingCode ? null : _sendCode,
              child: isSendingCode
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Continue',
                      style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Verification code section (shown after code is sent)
            if (columnVisible)
              Column(
                children: [
                  TextField(
                    controller: _verificationCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    enabled: !isVerifyingCode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Verification Code',
                      hintText: '000000',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      counterText: '',
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: isResendingCode ? null : _resendCode,
                        icon: Icon(Icons.refresh, size: 18),
                        label: Text(isResendingCode ? 'Sending...' : 'Resend Code'),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Text(
                          'Expires: $formattedTime',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isVerifyingCode ? null : _verifyCode,
                    child: isVerifyingCode
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Verifying...'),
                            ],
                          )
                        : Text(
                            'Verify and Continue',
                            style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
