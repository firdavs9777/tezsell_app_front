import 'package:app/pages/authentication/login.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/tab_bar/splash_screen.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));

// Theming
// Dark Color Value
var kDarkColorSchema = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));

class Welcome extends ConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        darkTheme: ThemeData.dark().copyWith(
            colorScheme: kDarkColorSchema,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kColorScheme.primaryContainer)),
            cardTheme: const CardTheme().copyWith(
                color: kDarkColorSchema.secondaryContainer,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8))),
        theme: ThemeData().copyWith(
            useMaterial3: true,
            colorScheme: kColorScheme,
            appBarTheme: const AppBarTheme().copyWith(
                backgroundColor: kColorScheme.onPrimaryContainer,
                foregroundColor: kColorScheme.primaryContainer),
            cardTheme: const CardTheme().copyWith(
                color: kColorScheme.secondaryContainer,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kColorScheme.primaryContainer)),
            textTheme: ThemeData().textTheme.copyWith(
                  titleLarge: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kColorScheme.onSecondaryContainer,
                      fontSize: 16),
                )),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen()
        // home: SafeArea(
        //   child: Home(),
        // ),
        );
  }
}
