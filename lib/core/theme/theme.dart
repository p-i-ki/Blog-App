import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 3),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: AppPallete.backgroundColor),
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),
      errorBorder: _border(AppPallete.errorColor),
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(AppPallete.backgroundColor),
      side: BorderSide.none,
    ),
  );
}
