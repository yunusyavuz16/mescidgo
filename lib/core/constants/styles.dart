import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';

class Styles {
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: AppColors.nearBlack,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16.0,
    color: AppColors.nearBlack,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.black87,
    backgroundColor: Colors.white
  );

  static const TextStyle successTextStyleSmall = TextStyle(
    fontSize: 14.0,
    color: Colors.white,
  );

  // Font Sizes
  static const double titleFontSize = 24.0;
  static const double subtitleFontSize = 18.0;
  static const double bodyFontSize = 16.0;

  // Border Radius
  static const BorderRadiusGeometry defaultBorderRadius =
      BorderRadius.all(Radius.circular(8.0));

  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(20.0);
  static const EdgeInsetsGeometry screenPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsetsGeometry buttonPadding = EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0);
}
