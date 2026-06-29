import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ================= LIGHT THEME =================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.tajawal().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
        onPrimaryContainer: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColor.primaryBlue),

        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      scaffoldBackgroundColor: const Color(0xffF6F8FC),
      cardColor: Colors.white,
      splashColor: Colors.grey.shade700,
      extensions: [
        AppThemeExtension(
          cardBackgroundColor: Colors.white,
          scaffoldGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffEBF1FC), Color(0xffF6F8FC)],
          ),
        ),
      ],
    );
  }

  // ================= DARK THEME =================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.tajawal().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
        onPrimaryContainer: Color(0xff1A1C20),
      ),
      splashColor: const Color.fromARGB(255, 223, 222, 222),

      scaffoldBackgroundColor: const Color.fromARGB(255, 23, 23, 23),
      cardColor: const Color(0xff1E1E1E),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1A1C20),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extensions: [
        AppThemeExtension(
          cardBackgroundColor: const Color(0xff1E1E1E),
          scaffoldGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1A1C20), Color(0xff121212)],
          ),
        ),
      ],
    );
  }
}
