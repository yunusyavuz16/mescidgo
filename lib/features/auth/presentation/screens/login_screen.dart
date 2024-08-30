import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/utils/navigation.dart';
import 'package:mescidgo/features/auth/presentation/screens/email_screen.dart';
import 'package:mescidgo/features/home/presentation/screens/home_screen.dart'; // Doğru yolu kontrol edin
import 'package:mescidgo/features/auth/presentation/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
                  try {
                    final GoogleSignInAccount? account = await _googleSignIn.signIn();
                    if (account != null) {
                      // Giriş başarılı, kullanıcı bilgileri burada işlenebilir
                      print('User signed in: ${account.displayName}');
                      // HomeScreen'e yönlendiriyoruz
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  } catch (error) {
                    print('Sign in failed: $error');
                  }
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
