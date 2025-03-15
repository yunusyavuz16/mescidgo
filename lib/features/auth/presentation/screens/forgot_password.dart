import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mescid_go/core/constants/colors.dart';
import 'package:mescid_go/core/widgets/custom_app_bar.dart';
import 'package:mescid_go/features/auth/presentation/widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
        showDialog(
          context: context,
          builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Sent'),
          content: Text('Password reset email sent'),
          actions: <Widget>[
            TextButton(
          child: Text('Tamam'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.of(context).pop(); // Navigate back
          },
            ),
          ],
        );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nearWhite,
      appBar: CustomAppBar(
        title: 'Şifremi Unuttum',
        showBackButton: true,
        titleCentered: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 100),
              const Text(
                'Şifrenizi sıfırlamak için e-posta adresinizi girin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.nearBlack,
                ),
              ),
              const SizedBox(height: 100),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen e-posta adresinizi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Send Password Reset Email',
                backgroundColor: AppColors.primaryGreen,
                textColor: AppColors.primaryBeige,
                onPressed: _resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
