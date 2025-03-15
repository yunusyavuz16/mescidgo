import 'package:flutter/material.dart';
import 'package:mescid_go/core/constants/colors.dart';
import 'package:mescid_go/core/widgets/custom_app_bar.dart';
import 'package:mescid_go/features/auth/presentation/screens/forgot_password.dart';
import 'package:mescid_go/features/auth/presentation/viewmodels/email_sign_in_viewmodel.dart';
import 'package:mescid_go/features/auth/presentation/widgets/custom_button.dart';
import 'package:mescid_go/features/auth/presentation/widgets/email_form.dart';

class EmailScreen extends StatelessWidget {
  final EmailSignInViewModel _viewModel = EmailSignInViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nearWhite,
      appBar: CustomAppBar(
        title: 'E-posta ile Giriş Yap',
        showBackButton: true,
        titleCentered: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              'E-postanızı ve şifrenizi kullanarak giriş yapın',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.nearBlack,
              ),
            ),
            const SizedBox(height: 100),
            EmailForm(viewModel: _viewModel),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              backgroundColor: AppColors.primaryGreen,
              textColor: AppColors.primaryBeige,
              onPressed: () => _viewModel.signIn(context),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
              },
              child: const Text(
                'Forget Password?',
                style: TextStyle(color: AppColors.primaryGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
