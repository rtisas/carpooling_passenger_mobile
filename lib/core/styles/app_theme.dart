import 'package:flutter/material.dart';

class AppTheme {
  static const colorPrimaryLightColor = Color(0xFF766588);
  static const colorPrimaryColor = Color(0xffBE202B);
  static const colorPrimaryDarkColor = Color(0xFF211531);
  static const colorSecondaryColor = Color(0xff1E1B4A);
  static const colorSecondaryLightColor = Color(0xFFffff51);
  static const colorSecondaryDarkColor = Color(0xFFc49e00);
  static const colorPrimaryTextColor = Color(0xFFffffff);
  static const colorSecondaryTextColor = Color(0xFF000000);
  static const colorPrimaryButton = Color(0xFF23177B);
  static const colorError = Color(0xffff4d6d);

  ThemeData getTheme() => ThemeData(
    // useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
    primary: colorPrimaryColor,

    ),

  );


}