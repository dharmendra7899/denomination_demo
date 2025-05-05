import 'package:denomination/theme/colors.dart';
import 'package:flutter/material.dart';

part 'widget/app_bar_theme.dart';
part 'widget/elevated_button_theme.dart';
part 'widget/input_decoration_theme.dart';
part 'widget/text_theme.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark();

  static final lightThemeMode = ThemeData(
    fontFamily: 'Montserrat',
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
    scaffoldBackgroundColor: appColors.appWhite,
    inputDecorationTheme: _inputDecorationTheme,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: appColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: appColors.appGreen, width: 4),
        ),
      ),
    ),
  );
}
