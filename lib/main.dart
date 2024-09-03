import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mescidgo/features/auth/presentation/screens/login_screen.dart';
import 'package:mescidgo/features/home/presentation/screens/home_screen.dart';
import 'package:mescidgo/features/settings/presentation/screens/settings_screen.dart';
import 'package:mescidgo/features/splash/presentation/splash_screen.dart';
import 'package:mescidgo/features/userPrayerTimes/presentation/screens/user_prayer_times_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('tr', null);
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
        '/settings': (context) => SettingsScreen(),
        '/user-prayer-times': (context) => UserPrayerTimesScreen(),
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
