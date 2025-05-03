import 'package:flutter/material.dart';

class AppThemes {
  // Define const colors where possible (Analyzer suggestion)
  static final Color _darkPrimary = Colors.amber[700]!;
  static const Color _darkBackground = Colors.black;
  static final Color _darkSurface = Colors.grey[900]!;
  static const Color _darkOnSurface = Colors.white;
  static const Color _darkOnPrimary = Colors.black;
  static final Color _darkError = Colors.redAccent[700]!;

  static final Color _lightPrimary = Colors.amber[800]!; // Keep gold accent?
  static final Color _lightBackground = Colors.grey[100]!;
  static const Color _lightSurface = Colors.white;
  static const Color _lightOnSurface = Colors.black87;
  static const Color _lightOnPrimary = Colors.white;
  static final Color _lightError = Colors.red[700]!;

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimary,
    scaffoldBackgroundColor: _darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkBackground,
      foregroundColor: _darkPrimary, // Icon/Title color
      elevation: 0,
      titleTextStyle: TextStyle(color: _darkPrimary, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: _darkPrimary),
    ),
    colorScheme: ColorScheme.dark(
      primary: _darkPrimary,
      secondary: _darkPrimary, // Often same as primary or a variant
      surface: _darkSurface,
      onPrimary: _darkOnPrimary,
      onSecondary: _darkOnPrimary,
      onSurface: _darkOnSurface,
      error: _darkError,
      onError: Colors.white,
    ),
    cardColor: _darkSurface,
    dividerColor: Colors.grey[800],
    iconTheme: IconThemeData(color: _darkPrimary),
    primaryIconTheme: IconThemeData(color: _darkPrimary),
    buttonTheme: ButtonThemeData(
      buttonColor: _darkPrimary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimary,
        foregroundColor: _darkOnPrimary,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkPrimary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[850],
      labelStyle: TextStyle(color: _darkPrimary),
      hintStyle: TextStyle(color: Colors.grey[600]),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _darkPrimary)),
      prefixIconColor: _darkPrimary,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return _darkPrimary;
        }
        return null; // Default
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return _darkPrimary.withOpacity(0.5);
        }
        return Colors.grey[700];
      }),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _darkSurface,
      disabledColor: Colors.grey[800]!,
      selectedColor: _darkPrimary,
      secondarySelectedColor: _darkPrimary,
      labelStyle: const TextStyle(color: _darkOnSurface), // Use const
      secondaryLabelStyle: const TextStyle(color: _darkOnPrimary), // Use const
      brightness: Brightness.dark,
      padding: const EdgeInsets.all(8.0),
    ),
    // Add other theme properties as needed
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimary,
    scaffoldBackgroundColor: _lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightSurface,
      foregroundColor: _lightPrimary, // Icon/Title color
      elevation: 1,
      titleTextStyle: TextStyle(color: _lightPrimary, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: _lightPrimary),
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimary,
      secondary: _lightPrimary, // Often same as primary or a variant
      surface: _lightSurface,
      onPrimary: _lightOnPrimary,
      onSecondary: _lightOnPrimary,
      onSurface: _lightOnSurface,
      error: _lightError,
      onError: Colors.white,
    ),
    cardColor: _lightSurface,
    dividerColor: Colors.grey[300],
    iconTheme: IconThemeData(color: _lightPrimary),
    primaryIconTheme: IconThemeData(color: _lightPrimary),
    buttonTheme: ButtonThemeData(
      buttonColor: _lightPrimary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightPrimary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      labelStyle: TextStyle(color: _lightPrimary),
      hintStyle: TextStyle(color: Colors.grey[500]),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _lightPrimary)),
      prefixIconColor: _lightPrimary,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return _lightPrimary;
        }
        return null; // Default
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return _lightPrimary.withOpacity(0.5);
        }
        return Colors.grey[400];
      }),
    ),
     chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[300]!,
      disabledColor: Colors.grey[400]!,
      selectedColor: _lightPrimary,
      secondarySelectedColor: _lightPrimary,
      labelStyle: const TextStyle(color: _lightOnSurface), // Use const
      secondaryLabelStyle: const TextStyle(color: _lightOnPrimary), // Use const
      brightness: Brightness.light,
      padding: const EdgeInsets.all(8.0),
    ),
    // Add other theme properties as needed
  );
}

