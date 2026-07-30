import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        fontFamily: AppFonts.bodyFont,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor.light,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor.light,
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        fontFamily: AppFonts.bodyFont,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor.dark,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor.dark,
      );
}
