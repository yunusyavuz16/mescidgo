import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final Color? borderColors;
  final bool isLoading;
  final IconData? icon; // Property for icon
  final Image? image; // New property for image
  final Container? container;

  const CustomButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColors,
    this.onPressed,
    this.isLoading = false,
    this.icon, // Initialize icon
    this.image, // Initialize image
    this.container,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColors ?? backgroundColor, width: 2),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                  SizedBox(width: 20),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor, size: 28),
                    SizedBox(width: 10),
                  ],
                  if (image != null) ...[image!, SizedBox(width: 10)],
                  if (container != null) ...[container!, SizedBox(width: 10)],
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
    );
  }
}
