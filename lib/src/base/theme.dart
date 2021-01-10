import 'package:flutter/material.dart';

abstract class AppTheme {
  static const primaryColor = Color(0xFFFC4346);

  static final data = ThemeData(
    accentColor: Colors.white,
    primaryColor: primaryColor,
    fontFamily: 'SourceSansPro',
    appBarTheme: const AppBarTheme(elevation: 0),
    // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
    ),
    textTheme: TextTheme(
      headline4: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
  );
}
