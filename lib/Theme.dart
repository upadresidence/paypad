import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFF37393A);
  static const Color loginGradientEnd = const Color(0xFF77B6EA);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color warningColor = const Color(0xFFFF0000);
  static const Color plainColor = const Color(0xFF000000);
  static const Color goodColor = const Color(0xFF00FF00);

  static const Color appBarTitle = const Color(0xFFFFFFFF);
  static const Color appBarIconColor = const Color(0xFFFFFFFF);
  static const Color appBarDetailBackground = const Color(0x00FFFFFF);
  static const Color appBarGradientStart = const Color(0xFF77B6EA);
  static const Color appBarGradientEnd = const Color(0xFF37393A);
}
