import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mescidgo/features/auth/presentation/screens/login_screen.dart';
import 'package:mescidgo/features/home/presentation/screens/home_screen.dart';
import 'package:mescidgo/features/splash/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pray App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),

        // Add other routes here
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While loading, show splash screen or a loading indicator
          return SplashScreen();
        } else if (snapshot.hasData) {
          // If user is logged in, show the HomeScreen
          return HomeScreen();
        } else {
          // If user is not logged in, show the LoginScreen
          return LoginScreen();
        }
      },
    );
  }
}
