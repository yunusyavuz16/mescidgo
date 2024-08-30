import 'package:flutter/material.dart';

class NavigationUtil {
  // Navigate to a named route
  static void navigateToNamed(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Navigate to a new screen
  static void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Navigate and replace the current screen
  static void replaceWithNamed(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Navigate and replace the current screen without adding to the back stack
  static void replaceWith(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
