import 'dart:io';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/store/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordReset extends StatefulWidget {
  final String regionName;
  final String districtName;
  final String districtId;
  final String phone_number;

  const PasswordReset({
    super.key,
    required this.regionName,
    required this.districtName,
    required this.districtId,
    required this.phone_number,
  });

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  bool _isObscure = true;
  bool _isObscure_secondary = true;
  bool _isLoading = false;
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

      // Pass the selected images to the registration service
      final result = await authService.register(
        widget.phone_number,
        password,
        userName,
        widget.regionName,
        widget.districtName,
        widget.districtId,
        _selectedImages.isNotEmpty ? _selectedImages[0] : null,
      );

      if (!mounted) return;

      if (result != null) {
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
      if (errorString.contains('phone number already exists') ||
          errorString.contains('user with this phone number')) {
        errorMessage = AppLocalizations.of(context)?.phoneExists ??
            'Bu telefon raqami allaqachon ro\'yxatdan o\'tgan';
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.passwordVerification ??
            'Password Verification'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.completeRegistrationPrompt ??
                        'Foydalanuvchi ismini va parol kiriting va ro\'yxatdan o\'tishni yakunlang',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Username field with validation
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _userNameController,
                  validator: _validateUsername,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.username ??
                        'Foydalanuvchi Ism',
                    hintText: AppLocalizations.of(context)?.usernameHint ??
                        'Kimsanboy77',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Password field with validation
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  validator: _validatePassword,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      child: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: _isObscure ? Colors.grey : Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: AppLocalizations.of(context)?.enterPassword ??
                        'Parolni Kiriting',
                    helperText: AppLocalizations.of(context)?.passwordHelp ??
                        'Kamida 8 belgi, harf va raqam',
                    helperMaxLines: 2,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorMaxLines: 2,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Password confirmation field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordConfirmationController,
                  obscureText: _isObscure_secondary,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.confirmPasswordRequired ??
                          'Parolni tasdiqlash majburiy';
                    }
                    if (value != _passwordController.text) {
                      return AppLocalizations.of(context)
                              ?.passwordsDoNotMatch ??
                          'Parollar mos kelmayapti';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isObscure_secondary = !_isObscure_secondary;
                        });
                      },
                      child: Icon(
                        _isObscure_secondary
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _isObscure_secondary ? Colors.grey : Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: AppLocalizations.of(context)?.confirmPassword ??
                        'Parolni tasdiqlang',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorMaxLines: 2,
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Profile image picker
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: AppLocalizations.of(context)?.profileImage ??
                        'Profile Image',
                    prefixIcon: Icon(Icons.image_outlined),
                  ),
                  readOnly: true,
                  onTap: _isLoading ? null : _pickImage,
                ),
              ),

              if (_selectedImages.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.imageInstructions ??
                          'Images will appear here, please press profile image',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),

              if (_selectedImages.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: _selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index < _selectedImages.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          _selectedImages[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: _isLoading ? null : _pickImage,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.add, size: 50),
                          ),
                        ),
                      );
                    }
                  },
                ),

              SizedBox(height: 15),

              // Submit button with loading state
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegistration,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Text(
                            AppLocalizations.of(context)?.finish ?? 'Yakunlash',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        _isLoading ? Colors.grey : Colors.blue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
