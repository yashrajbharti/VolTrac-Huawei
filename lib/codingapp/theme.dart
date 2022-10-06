import 'package:flutter/material.dart';

const MaterialColor myColour = const MaterialColor(
  0xFFCCCCCC,
  const <int, Color>{
    50: Color.fromARGB(255, 204, 204, 204),
    100: Color.fromARGB(255, 204, 204, 204),
    200: Color.fromARGB(255, 204, 204, 204),
    300: Color.fromARGB(255, 204, 204, 204),
    400: Color.fromARGB(255, 204, 204, 204),
    500: Color.fromARGB(255, 204, 204, 204),
    600: Color.fromARGB(255, 204, 204, 204),
    700: Color.fromARGB(255, 204, 204, 204),
    800: Color.fromARGB(255, 204, 204, 204),
    900: Color.fromARGB(255, 204, 204, 204),
  },
);
const MaterialColor yourColour = const MaterialColor(
  0xFF101010,
  const <int, Color>{
    50: Color.fromARGB(255, 16, 16, 16),
    100: Color.fromARGB(255, 16, 16, 16),
    200: Color.fromARGB(255, 16, 16, 16),
    300: Color.fromARGB(255, 16, 16, 16),
    400: Color.fromARGB(255, 16, 16, 16),
    500: Color.fromARGB(255, 16, 16, 16),
    600: Color.fromARGB(255, 16, 16, 16),
    700: Color.fromARGB(255, 16, 16, 16),
    800: Color.fromARGB(255, 16, 16, 16),
    900: Color.fromARGB(255, 16, 16, 16),
  },
);
final isLightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(color: myColour),
  scaffoldBackgroundColor: myColour,
  fontFamily: 'GoogleSans',
  textTheme: TextTheme(
    button: TextStyle(fontSize: 18.0),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: myColour,
    brightness: Brightness.light,
  ).copyWith(secondary: Color.fromARGB(255, 125, 164, 243)),
);
final isDarkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(color: yourColour),
  scaffoldBackgroundColor: yourColour,
  fontFamily: 'GoogleSans',
  textTheme: TextTheme(
    button: TextStyle(fontSize: 18.0),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: yourColour,
    brightness: Brightness.dark,
  ).copyWith(secondary: Color.fromARGB(255, 125, 164, 243)),
);
