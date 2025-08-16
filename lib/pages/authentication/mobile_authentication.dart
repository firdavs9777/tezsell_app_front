import 'package:app/pages/authentication/password_set.dart';
import 'package:flutter/material.dart';
import 'package:app/service/mobile_authentication.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  String _countryCode = '+998';
  String _countryName = 'Uzbekistan';

  bool columnVisible = false;
  bool isSendingCode = false;
  bool isResendingCode = false;
  bool isValid = false;
  Timer? _timer; // Timer to track 5 minutes
  int _timeLeft = 300; // 5 minutes in seconds

  // Get full phone number with country code
  String get fullPhoneNumber => '$_countryCode${_phoneNumberController.text}';

  // Verifying the code and navigating to the next step if valid
  Future<void> _verifyCode() async {
    final phoneNumber = fullPhoneNumber;
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
        SnackBar(
          content: Text(AppLocalizations.of(context)?.invalidVerificationCode ??
              'Invalid verification code'),
        ),
      );
    }
  }

  // Sending the verification code to the phone number
  Future<void> _sendCode() async {
    if (_phoneNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.pleaseEnterPhoneNumber ??
              'Please enter your phone number'),
        ),
      );
      return;
    }

    setState(() {
      isSendingCode = true;
    });

    final phoneNumber = fullPhoneNumber;
    if (await sendVerificationCode(phoneNumber)) {
      setState(() {
        columnVisible = true;
        isSendingCode = false;
        _timeLeft = 300; // Reset timer
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.verificationCodeSent ??
              'Verification code sent successfully'),
        ),
      );

      // Start the 5-minute timer after the code is sent
      _startTimer();
    } else {
      setState(() {
        isSendingCode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.failedToSendCode ??
              'Failed to send verification code'),
        ),
      );
    }
  }

  // Resending the verification code
  Future<void> _resendCode() async {
    setState(() {
      isResendingCode = true;
    });

    final phoneNumber = fullPhoneNumber;
    if (await sendVerificationCode(phoneNumber)) {
      setState(() {
        isResendingCode = false;
        _timeLeft = 300; // Reset timer
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.verificationCodeResent ??
              'Verification code resent successfully'),
        ),
      );

      // Restart the timer if the code is resent
      _startTimer();
    } else {
      setState(() {
        isResendingCode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.failedToResendCode ??
              'Failed to resend verification code'),
        ),
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
    _phoneNumberController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.phoneVerification ??
            'Telefon No\'merni Tasdiqlash'),
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
              AppLocalizations.of(context)?.enterPhonePrompt ??
                  'Iltimos telefon raqamingizni kiriting',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // Country Code Picker + Phone number input
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  // Country Code Picker
                  CountryCodePicker(
                    onChanged: (country) {
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
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    textStyle: TextStyle(fontSize: 16),
                  ),

                  // Divider line
                  Container(
                    height: 50,
                    width: 1,
                    color: Colors.grey.shade400,
                  ),

                  // Phone number input
                  Expanded(
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                                ?.enterPhoneNumberHint ??
                            'Enter phone number',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Show selected country and full number preview
            Text(
              AppLocalizations.of(context)
                      ?.selectedCountry(_countryName, _countryCode) ??
                  'Selected: $_countryName ($_countryCode)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (_phoneNumberController.text.isNotEmpty)
              Text(
                AppLocalizations.of(context)?.fullNumber(fullPhoneNumber) ??
                    'Full number: $fullPhoneNumber',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                ),
              ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: isSendingCode ? null : _sendCode,
              child: isSendingCode
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      AppLocalizations.of(context)?.sendCode ?? 'Kod Yuborish',
                      style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
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
                      labelText:
                          AppLocalizations.of(context)?.enterVerificationCode ??
                              'Enter verification code',
                      hintText:
                          AppLocalizations.of(context)?.verificationCodeHint ??
                              '123456',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(AppLocalizations.of(context)?.resendCode ??
                                'Resend Code'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 45),
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Text(
                          AppLocalizations.of(context)
                                  ?.expires(formattedTime) ??
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _verifyCode,
                    child: Text(
                        AppLocalizations.of(context)?.verifyAndContinue ??
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
