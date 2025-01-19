import 'package:app/pages/authentication//login.dart';
import 'package:app/pages/authentication//register.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfdf8e4),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Har qanday mahsulotingizni faqat bizda soting va sotib oling',
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.secondary.withBlue(2),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25.0),
                  Text(
                    'Ishlatilgan mahsulotlar yoki ikkinchi qo\'l bozori',
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.secondary.withBlue(2),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0), // Add spacing above the logo
                  Image.asset(
                    'assets/logo/logo.png',
                    width: 0.5 *
                        MediaQuery.of(context).size.width, // Adjust logo size
                    fit: BoxFit.contain,
                  ),
                  // Add spacing below the logo
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 30.0),
                    child: Column(
                      children: [
                        Container(
                          height: 45.0,
                          width: 0.9 *
                              MediaQuery.of(context)
                                  .size
                                  .width, // 90% of the screen width
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register())),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors
                                      .orange), // Set your custom background color
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Set your custom border radius
                                ),
                              ),
                            ),
                            child: Text(
                              'Ro\'yhatdan o\'tish',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 45.0,
                          width: 0.9 *
                              MediaQuery.of(context)
                                  .size
                                  .width, // 90% of the screen width
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login())),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF92868a)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Set your custom border radius
                                ),
                              ), // Set your custom background color
                            ),
                            child: Text(
                              'Allaqachon hisob mavjud',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
