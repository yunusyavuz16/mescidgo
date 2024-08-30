import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/utils/navigation.dart';
import 'package:mescidgo/features/auth/presentation/screens/email_screen.dart';
import 'package:mescidgo/features/auth/presentation/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBeige,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.nearBlack,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 40),
              CustomButton(
                text: 'Sign in with Google',
                backgroundColor: AppColors.primaryGreen,
                textColor: AppColors.primaryBeige,
                onPressed: () {
                  // Google Sign-In functionality here
                },
              ),
              SizedBox(height: 20),
              Text(
                'or',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.nearBlack),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Sign in with Email',
                backgroundColor: AppColors.nearBlack,
                textColor: AppColors.primaryBeige,
                onPressed: () {
                  NavigationUtil.navigateTo(context, EmailScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
