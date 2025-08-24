import 'package:app/pages/tab_bar/splash_screen.dart';
import 'package:app/providers/provider_root/locale_provider.dart';
import 'package:app/providers/provider_root/theme_provider.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Enhanced Color Schemes with Carrot-style branding
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFFFF6F00), // Carrot Orange
  brightness: Brightness.light,
);

var kDarkColorSchema = ColorScheme.fromSeed(
  seedColor: const Color(0xFFFF6F00), // Same Carrot Orange for consistency
  brightness: Brightness.dark,
);

class Welcome extends ConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider); // Watch theme provider

    print('Current locale in Welcome: ${locale?.languageCode}');
    print('Current theme mode: $themeMode');

    return MaterialApp(
      // Locale Configuration
      locale: locale ?? const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ru'), // Russian
        Locale('uz'), // Uzbek
      ],

      // Theme Configuration
      themeMode: themeMode, // Use theme mode from provider

      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: kColorScheme,
        brightness: Brightness.light,

        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: kColorScheme.onSurface,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: kColorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Card Theme
        cardTheme: CardTheme(
          color: kColorScheme.surface,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shadowColor: Colors.black.withOpacity(0.1),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primary,
            foregroundColor: kColorScheme.onPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),

        // Text Theme
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kColorScheme.onSurface,
            fontSize: 20,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: kColorScheme.onSurface,
            fontSize: 16,
          ),
          bodyLarge: TextStyle(
            color: kColorScheme.onSurface,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: kColorScheme.onSurface.withOpacity(0.8),
            fontSize: 14,
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kColorScheme.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kColorScheme.primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: kColorScheme.primary,
          unselectedItemColor: kColorScheme.onSurface.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.onPrimary,
          elevation: 4,
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: kDarkColorSchema,
        brightness: Brightness.dark,

        // App Bar Theme for Dark
        appBarTheme: AppBarTheme(
          backgroundColor: kDarkColorSchema.surface,
          foregroundColor: kDarkColorSchema.onSurface,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: kDarkColorSchema.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Card Theme for Dark
        cardTheme: CardTheme(
          color: kDarkColorSchema.surfaceVariant,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shadowColor: Colors.black.withOpacity(0.3),
        ),

        // Elevated Button Theme for Dark
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorSchema.primary,
            foregroundColor: kDarkColorSchema.onPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),

        // Text Theme for Dark
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kDarkColorSchema.onSurface,
            fontSize: 20,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: kDarkColorSchema.onSurface,
            fontSize: 16,
          ),
          bodyLarge: TextStyle(
            color: kDarkColorSchema.onSurface,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: kDarkColorSchema.onSurface.withOpacity(0.8),
            fontSize: 14,
          ),
        ),

        // Input Decoration Theme for Dark
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kDarkColorSchema.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kDarkColorSchema.primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),

        // Bottom Navigation Bar Theme for Dark
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kDarkColorSchema.surface,
          selectedItemColor: kDarkColorSchema.primary,
          unselectedItemColor: kDarkColorSchema.onSurface.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // Floating Action Button Theme for Dark
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kDarkColorSchema.primary,
          foregroundColor: kDarkColorSchema.onPrimary,
          elevation: 4,
        ),

        // Scaffold Background for Dark
        scaffoldBackgroundColor: kDarkColorSchema.background,
      ),

      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
