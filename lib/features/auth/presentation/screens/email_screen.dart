import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/features/auth/presentation/widgets/custom_button.dart';

class EmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBeige,
      appBar: AppBar(
        title: Text('Sign in with Email'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              backgroundColor: AppColors.primaryGreen,
              textColor: AppColors.primaryBeige,
              onPressed: () {
                // Email sign-in functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}
