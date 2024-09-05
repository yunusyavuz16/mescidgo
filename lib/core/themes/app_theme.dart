import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.primaryBeige,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.nearBlack),  // bodyText1 yerine
        bodyMedium: TextStyle(color: AppColors.nearBlack), // bodyText2 yerine
        titleLarge: TextStyle( // headline6 yerine
          color: AppColors.nearBlack,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primaryGreen,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
