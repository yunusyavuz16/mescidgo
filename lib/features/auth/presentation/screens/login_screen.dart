import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/widgets/custom_loading_overlay.dart';
import 'package:mescidgo/features/auth/presentation/screens/email_screen.dart';
import 'package:mescidgo/features/auth/presentation/screens/register_screen.dart';
import 'package:mescidgo/features/auth/presentation/widgets/custom_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  bool _isLoadingGoogle = false;
  bool _isLoadingApple = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoadingGoogle = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      final DateTime now = DateTime.now();

      await _database
          .ref()
          .child('users')
          .child(user!.uid)
          .child('lastSignInTime')
          .update({'lastSignInTime': now.toString()});

      await _database
          .ref()
          .child('users')
          .child(user.uid)
          .child('email')
          .set(user.email);

      await _database
          .ref()
          .child('users')
          .child(user.uid)
          .child('name')
          .set(user.displayName!.split(' ')[0]);

      await _database
          .ref()
          .child('users')
          .child(user.uid)
          .child('surname')
          .set(user.displayName!.split(' ')[1]);

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
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
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(oauthCredential);
      final User? user = userCredential.user;

      if (user != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
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
      backgroundColor: AppColors.lightGrey,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/image.png',
                    width: MediaQuery.of(context)
                        .size
                        .width, // Ekranın tamamını kaplar
                    height: 150,
                    fit: BoxFit.cover, // Resmi kapsayacak şekilde kırpar
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'MescidGo\' ya Hoş Geldiniz!',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.nearBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Bugüne kadarki kazalarınızı kolayca hesaplayın. \nHadi başlayalım!',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.nearBlack,
                                  ),
                        ),
                        SizedBox(height: 40),
                        CustomButton(
                          text: 'Sign in with Google',
                          backgroundColor: AppColors.primaryGreen,
                          textColor: AppColors.primaryBeige,
                          isLoading: _isLoadingGoogle,
                          onPressed:
                              _isLoadingGoogle ? null : _signInWithGoogle,
                        ),
                        SizedBox(height: 20),
                        CustomButton(
                          text: 'Sign in with Apple',
                          backgroundColor: Colors.black,
                          textColor: AppColors.primaryBeige,
                          isLoading: _isLoadingApple,
                          onPressed: _isLoadingApple ? null : _signInWithApple,
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => EmailScreen()),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        CustomButton(
                          text: 'Register',
                          backgroundColor: AppColors.primaryBeige,
                          textColor: AppColors.nearBlack,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
}
