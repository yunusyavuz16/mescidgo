import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isLoading; // Yeni özellik

  const CustomButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
    this.isLoading = false, // Varsayılan olarak false
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
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
                SizedBox(width: 20),
                Text(
                  text,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
    );
  }
}
