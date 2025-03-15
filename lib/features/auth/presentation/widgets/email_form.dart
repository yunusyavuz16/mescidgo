// lib/features/auth/presentation/widgets/email_form.dart
import 'package:flutter/material.dart';
import 'package:mescid_go/core/constants/colors.dart';
import 'package:mescid_go/features/auth/presentation/viewmodels/email_sign_in_viewmodel.dart';

class EmailForm extends StatelessWidget {
  final EmailSignInViewModel viewModel;

  EmailForm({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: viewModel.emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            floatingLabelStyle: TextStyle(color: AppColors.primaryBlue),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryBlue),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: viewModel.passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            floatingLabelStyle: TextStyle(color: AppColors.primaryBlue),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryBlue),
            ),
          ),
          obscureText: true,
        ),
      ],
    );
  }
}
