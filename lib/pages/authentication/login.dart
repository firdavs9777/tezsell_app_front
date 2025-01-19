import 'package:app/pages/authentication/register.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/store/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;
  late AuthenticationService authService;

  bool _isPasswordVisible = false; // State variable for password visibility

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    authService = AuthenticationService(authStatesProvider);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Hisobga Kirish',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Center(
                child: Text(
                  'Hisobga Kirish',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                // Fixed country code
                Container(
                  height: 50,
                  width: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: const Text(
                      '+82',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // Editable phone number
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Telefon Raqam',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Parol',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: 200.0,
              child: ElevatedButton(
                onPressed: () async {
                  final String phoneNumber =
                      '+82${_phoneNumberController.text.trim()}';
                  final String password = _passwordController.text;

                  final check =
                      await authService.login(context, phoneNumber, password);
                  print(_phoneNumberController.text);
                  print(_passwordController.text);
                  print(check);

                  if (check != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const TabsScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                child: Text(
                  'Kirish',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Implement forgot password logic
                  },
                  child: const Text('Parolni unutdingizmi?'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const Register()),
                    );
                  },
                  child: const Text('Ro\'yhatdan o\'tish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
