import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final Color? borderColors; // Yeni özellik
  final bool isLoading; // Yeni özellik

  const CustomButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    // borderColors: borderColors ?? backgroundColor,
    this.borderColors,
    this.onPressed,
    this.isLoading = false, // Varsayılan olarak false
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        // bordering
        foregroundColor: textColor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColors ?? backgroundColor, width: 2),
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
                  style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}
