import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart'; // Doğru yolu kontrol edin

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Center(
        child: Text(
          'Welcome to Home Screen!',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.nearBlack,
          ),
        ),
      ),
    );
  }
}
