import 'package:flutter/material.dart';

class CustomLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String message;

  const CustomLoadingOverlay({
    required this.isLoading,
    this.message = 'Please wait...',
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
