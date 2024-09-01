import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/features/auth/presentation/screens/email_screen.dart';
import 'package:mescidgo/features/home/presentation/screens/home_screen.dart';
import 'package:mescidgo/features/auth/presentation/screens/register_screen.dart'; // Import the register screen
import 'package:mescidgo/features/auth/presentation/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle(BuildContext context) async {
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

      if (user != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }
    } catch (e) {
      print('Google Sign-In failed: $e');
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
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
      print('Apple Sign-In failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
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
                onPressed: () async {
                  await _signInWithGoogle(context);
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Sign in with Apple',
                backgroundColor: Colors.black,
                textColor: AppColors.primaryBeige,
                onPressed: () async {
                  await _signInWithApple(context);
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
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EmailScreen()),
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
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
