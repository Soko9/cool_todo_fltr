import 'package:flutter/material.dart';

class Styles {
  static EdgeInsets defaultPadding = const EdgeInsets.symmetric(
    vertical: 8.0,
    horizontal: 16.0,
  );

  static TextStyle lightTextStyle({
    double size = 12,
    Color color = Colors.black,
  }) =>
      TextStyle(
        fontFamily: "HermitLight",
        letterSpacing: -1.2,
        fontSize: size,
        color: color,
      );

  static TextStyle regularTextStyle({
    double size = 12,
    Color color = Colors.black,
  }) =>
      TextStyle(
        fontFamily: "Hermit",
        letterSpacing: -1.2,
        fontSize: size,
        color: color,
      );

  static TextStyle boldTextStyle({
    double size = 12,
    Color color = Colors.black,
  }) =>
      TextStyle(
        fontFamily: "HermitBold",
        letterSpacing: -1.2,
        fontSize: size,
        color: color,
      );
}
