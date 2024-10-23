import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color(0xff000000);
  static Color white = const Color(0xffffffff);
  static Color gray = const Color(0xff808080);
  static Color red = const Color(0xffff0000);

  // Method to get a darker shade of the primary color
  static Color get primaryDarker {
    return _adjustBrightness(primary, factor: 0.7);
  }

  // Method to get a lighter (whiter) shade of the primary color
  static Color get primaryWhiter {
    return _adjustOpacity(_adjustBrightness(primary, factor: 1.3), 0.15);
  }

  // Helper method to adjust brightness
  static Color _adjustBrightness(Color color, {double factor = 1.0}) {
    int red = (color.red * factor).clamp(0, 255).toInt();
    int green = (color.green * factor).clamp(0, 255).toInt();
    int blue = (color.blue * factor).clamp(0, 255).toInt();
    return Color.fromARGB(color.alpha, red, green, blue);
  }

  // Helper method to adjust opacity
  static Color _adjustOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static const Color mainTxt = Color(0xFF808080);
  static Color shadowColor = const Color(0xffCF989F).withOpacity(0.6);
  static const Color surfaceLight = Color(0xFFF2F2F2);

  static const Color switcherBackground = Color(0xffEFEFEF);
  static const Color divider = Color(0xffD9D9D9);
}
