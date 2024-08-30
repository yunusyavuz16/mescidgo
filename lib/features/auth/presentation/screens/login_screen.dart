import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/features/auth/presentation/screens/email_screen.dart';
import 'package:mescidgo/features/home/presentation/screens/home_screen.dart';
import 'package:mescidgo/features/auth/presentation/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Google ile oturum aç
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Kullanıcı oturum açmayı iptal etti
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase'de oturum açmak için kimlik bilgileri oluştur
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase'de oturum aç
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Kullanıcı başarılı bir şekilde Firebase'de oturum açtı
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      print('Google Sign-In failed: $e');
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
            ],
          ),
        ),
      ),
    );
  }
}
