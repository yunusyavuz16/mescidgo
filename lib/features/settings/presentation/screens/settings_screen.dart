import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/constants/styles.dart';
import 'package:mescidgo/core/utils/navigation.dart';
import 'package:mescidgo/core/widgets/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      NavigationUtil.replaceWithNamed(context, '/login');
    } catch (e) {
      print('Sign out failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Settings', showBackButton: true, titleCentered: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Settings',
              style: Styles.titleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: Styles.defaultBorderRadius,
                ),
              ),
              onPressed: () => _signOut(context),
              child: Text(
                'Sign Out',
                style: Styles.bodyTextStyle
                    .copyWith(color: AppColors.primaryBeige),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
