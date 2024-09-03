import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/widgets/custom_app_bar.dart';
import 'package:mescidgo/features/auth/presentation/widgets/custom_button.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Update the last sign-in time
      await _updateLastSignInTime(userCredential.user);
      print('Signed in: ${userCredential.user}');

      // Navigate to the next screen or show a success message
      print('Signed in: ${userCredential.user?.email}');
      // navigate to the home screen
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      // Handle errors here
      print('Failed to sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: ${e.message}')),
      );
    }
  }

  Future<void> _updateLastSignInTime(User? user) async {
    if (user != null) {
      String userId = user.uid;
      DateTime now = DateTime.now();
      await _dbRef.child('users/$userId').update({
        'lastSignInTime': now.toIso8601String(),
      });
      print('Updated last sign-in time for user: $userId');
    }
  }

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
            SizedBox(height: 100),
            Text(
              'E-postanızı ve şifrenizi kullanarak giriş yapın',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.nearBlack
              ),
            ),
            SizedBox(height: 100),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              backgroundColor: AppColors.primaryGreen,
              textColor: AppColors.primaryBeige,
              onPressed: _signInWithEmailAndPassword,
            ),
          ],
        ),
      ),
    );
  }
}
