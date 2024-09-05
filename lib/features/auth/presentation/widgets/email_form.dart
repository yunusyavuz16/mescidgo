// lib/features/auth/presentation/widgets/email_form.dart
import 'package:flutter/material.dart';
import 'package:mescidgo/features/auth/presentation/viewmodels/email_sign_in_viewmodel.dart';

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
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: viewModel.passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
      ],
    );
  }
}
