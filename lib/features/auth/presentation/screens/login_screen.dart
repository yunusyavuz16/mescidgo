import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/widgets/custom_loading_overlay.dart';
import 'package:mescidgo/features/auth/presentation/screens/email_screen.dart';
import 'package:mescidgo/features/auth/presentation/widgets/auth_service.dart';
import 'package:mescidgo/features/auth/presentation/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  bool _isLoadingGoogle = false;
  bool _isLoadingApple = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoadingGoogle = true;
    });

    try {
      final User? user = await authService.signInWithGoogle();
      if (user != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } catch (e) {
      _showErrorDialog('Google Sign-In failed: $e');
    } finally {
      setState(() {
        _isLoadingGoogle = false;
      });
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _isLoadingApple = true;
    });

    try {
      final User? user = await authService.signInWithApple();
      if (user != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } catch (e) {
      _showErrorDialog('Apple Sign-In failed: $e');
    } finally {
      setState(() {
        _isLoadingApple = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nearWhite,
      body: Stack(
        children: [
          _buildLoginContent(),
          CustomLoadingOverlay(
            isLoading: _isLoadingGoogle || _isLoadingApple,
            message: _isLoadingGoogle
                ? 'Signing in with Google...'
                : 'Signing in with Apple...',
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/image.png',
              width: MediaQuery.of(context).size.width,
              height: 150,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'MescidGo\' ya Hoş Geldiniz!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.nearBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bugüne kadarki kazalarınızı kolayca hesaplayın. \nHadi başlayalım!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.nearBlack,
                        ),
                  ),
                  SizedBox(height: 40),
                  _buildAuthButton(
                    text: 'Google ile Giriş Yap',
                    backgroundColor: AppColors.primaryBlue,
                    textColor: AppColors.nearWhite,
                    isLoading: _isLoadingGoogle,
                    onPressed: _isLoadingGoogle ? null : _signInWithGoogle,
                  ),
                  SizedBox(height: 20),
                  _buildAuthButton(
                    text: 'Apple ile Giriş Yap',
                    backgroundColor: Colors.black,
                    textColor: AppColors.nearWhite,
                    isLoading: _isLoadingApple,
                    onPressed: _isLoadingApple ? null : _signInWithApple,
                  ),
                  SizedBox(height: 20),
                  _buildAuthButton(
                    text: 'E-posta ile Giriş Yap',
                    backgroundColor: AppColors.primaryGreen,
                    textColor: AppColors.nearWhite,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EmailScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'or',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.nearBlack),
                  ),
                  SizedBox(height: 20),
                  _buildAuthButton(
                    text: 'Kayıt Ol',
                    backgroundColor: AppColors.nearWhite,
                    textColor: AppColors.primaryGreen,
                    borderColor: AppColors.primaryGreen,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return CustomButton(
      text: text,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColors: borderColor,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
