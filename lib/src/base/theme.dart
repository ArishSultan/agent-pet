import 'package:flutter/material.dart';

abstract class AppTheme {
  static const primaryColor = Color(0xFFFC4346);
  static const colors = <int, Color>{
    0: Color(0xFFFD4245),
    1: Color(0xFFF8A135),
    2: Color(0xFF7B43A5),
    3: Color(0xFF47B5E2)
  };

  static final data = ThemeData(
    accentColor: primaryColor,
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

  static final extendedPrimaryTextButton = TextButton.styleFrom(
    primary: Colors.white,
    backgroundColor: primaryColor,
    minimumSize: Size.fromHeight(45),
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'SourceSansPro',
    ),
  );
}
