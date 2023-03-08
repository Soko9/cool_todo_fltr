import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Themes {
  static Color lightBlue = const Color(0xFF0084FF);
  static Color lightRed = const Color(0xFFE92C2C);
  static Color lightGreen = const Color(0xFF00BA34);

  static Color darkBlue = const Color(0xFF73BCFF);
  static Color darkRed = const Color(0xFFFA8D8D);
  static Color darkGreen = const Color(0xFF74E092);

  static const Color primaryColor = Color(0xFFFFC17B);

  static Color lightBack = const Color(0xFFFFFFFF);
  static Color darkBack = const Color(0xFF121212);

  static Color darkGrey = const Color(0xFFC8C8C8);
  static Color lightGrey = const Color(0xFF363636);

  final _localStorage = GetStorage();
  final _themeKey = "isDarkMode";

  bool getThemeMode() => _localStorage.read(_themeKey) ?? false;

  void putThemeMode(bool isDarkMode) =>
      _localStorage.write(_themeKey, isDarkMode);

  ThemeMode get themeMode => getThemeMode() ? ThemeMode.dark : ThemeMode.light;

  void swithTheme() {
    Get.changeThemeMode(getThemeMode() ? ThemeMode.light : ThemeMode.dark);
    putThemeMode(!getThemeMode());
  }

  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Hermit",
    appBarTheme: AppBarTheme(
      backgroundColor: lightBlue,
      elevation: 0.0,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: lightBack,
    backgroundColor: lightGrey,
    errorColor: darkBack,
    dialogBackgroundColor: darkGrey,
    iconTheme: const IconThemeData(color: primaryColor, size: 32.0),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: lightBlue,
      secondary: lightRed,
      tertiary: lightGreen,
      brightness: Brightness.light,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Hermit",
    appBarTheme: AppBarTheme(
      backgroundColor: darkBlue,
      elevation: 0.0,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: darkBack,
    backgroundColor: darkGrey,
    errorColor: lightBack,
    dialogBackgroundColor: lightGrey,
    iconTheme: const IconThemeData(color: primaryColor, size: 32.0),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: darkBlue,
      secondary: darkRed,
      tertiary: darkGreen,
      brightness: Brightness.dark,
    ),
  );
}
