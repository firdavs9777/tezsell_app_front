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
  final String phone_number;

  const PasswordReset({
    super.key,
    required this.regionName,
    required this.districtName,
    required this.phone_number,
  });

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  bool _isObscure = true;
  bool _isObscure_secondary = true;
  late AuthenticationService authService;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

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

  @override
  void initState() {
    super.initState();
    authService = AuthenticationService(authStatesProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.passwordVerification ??
            'Password Verification'),
      ),
      body: Column(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.username ??
                    'Foydalanuvchi Ism',
                hintText:
                    AppLocalizations.of(context)?.usernameHint ?? 'Kimsanboy77',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _passwordController,
              obscureText: _isObscure,
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
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _passwordConfirmationController,
              obscureText: _isObscure_secondary,
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
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
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
              onTap: _pickImage,
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
                    onTap: _pickImage,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                String userName = _userNameController.text;
                String password = _passwordController.text;
                String passwordConfirmation =
                    _passwordConfirmationController.text;

                if (password != passwordConfirmation) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          AppLocalizations.of(context)?.passwordsDoNotMatch ??
                              'Parollar mos kelmayapti'),
                    ),
                  );
                  return;
                }

                // Pass the selected images to the registration service
                final check = await authService.register(
                  widget.phone_number,
                  password,
                  userName,
                  widget.regionName,
                  widget.districtName,
                  _selectedImages.isNotEmpty
                      ? _selectedImages[0]
                      : null, // Passing the image
                );
                print(check);
                if (check != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => const TabsScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          AppLocalizations.of(context)?.registrationError ??
                              'Ro\'yxatdan o\'tish xatolik'),
                    ),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  AppLocalizations.of(context)?.finish ?? 'Yakunlash',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
