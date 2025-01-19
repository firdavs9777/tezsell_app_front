import 'package:app/pages/authentication/password_set.dart';
import 'package:flutter/material.dart';
import 'package:app/service/mobile_authentication.dart';
import 'dart:async'; // Import the async library for Timer

class MobileAuthentication extends StatefulWidget {
  final String regionName;
  final String districtName;
  const MobileAuthentication(
      {super.key, required this.regionName, required this.districtName});

  @override
  State<MobileAuthentication> createState() => _MobileAuthenticationState();
}

class _MobileAuthenticationState extends State<MobileAuthentication> {
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '+82');
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool columnVisible = false;
  bool isSendingCode = false;
  bool isResendingCode = false;
  bool isValid = false;
  Timer? _timer; // Timer to track 5 minutes
  int _timeLeft = 300; // 5 minutes in seconds

  // Verifying the code and navigating to the next step if valid
  Future<void> _verifyCode() async {
    final phoneNumber = _phoneNumberController.text;
    final otp = _verificationCodeController.text;

    bool verificationSuccess = await verifyVerificationCode(phoneNumber, otp);
    if (verificationSuccess) {
      // If verification is successful, navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordReset(
              regionName: widget.regionName,
              districtName: widget.districtName,
              phone_number: phoneNumber),
        ),
      );
    } else {
      // If verification failed, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid verification code')),
      );
    }
  }

  // Sending the verification code to the phone number
  Future<void> _sendCode() async {
    setState(() {
      isSendingCode = true;
    });

    final phoneNumber = _phoneNumberController.text;
    if (await sendVerificationCode(phoneNumber)) {
      setState(() {
        columnVisible = true;
        isSendingCode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code sent successfully')),
      );

      // Start the 5-minute timer after the code is sent
      _startTimer();
    } else {
      setState(() {
        isSendingCode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification code')),
      );
    }
  }

  // Resending the verification code
  Future<void> _resendCode() async {
    setState(() {
      isResendingCode = true;
    });

    final phoneNumber = _phoneNumberController.text;
    if (await sendVerificationCode(phoneNumber)) {
      setState(() {
        isResendingCode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code resent successfully')),
      );

      // Restart the timer if the code is resent
      _startTimer();
    } else {
      setState(() {
        isResendingCode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend verification code')),
      );
    }
  }

  // Start the 5-minute timer
  void _startTimer() {
    // Cancel any existing timer
    _timer?.cancel();

    // Update time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel(); // Stop the timer after time runs out
        setState(() {
          columnVisible = false; // Hide verification input after time is up
        });
      }
    });
  }

  // Format the time remaining as mm:ss
  String get formattedTime {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telefon No\'merni Tasdiqlash'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Iltimos telefon raqamingizni kiriting',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Phone number input field
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Telefon Raqam',
                hintText: '+82 123-456-7890',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSendingCode ? null : _sendCode,
              child: isSendingCode
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Kod Junatish'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Verification code section
            if (columnVisible)
              Column(
                children: [
                  // Verification code input field
                  TextField(
                    controller: _verificationCodeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter verification code',
                      hintText: '123456',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: isResendingCode ? null : _resendCode,
                        child: isResendingCode
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Resend Code'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 50),
                          primary: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      Text(
                        'Expires in: $formattedTime', // Timer next to input
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _verifyCode,
                    child: Text('Verify and Continue'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
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
