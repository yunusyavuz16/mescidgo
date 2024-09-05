import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mescidgo/core/utils/prayer_time_checker.dart';
import 'package:mescidgo/features/auth/presentation/screens/login_screen.dart';
import 'package:mescidgo/features/auth/presentation/screens/register_screen.dart';
import 'package:mescidgo/features/auth/presentation/widgets/auth_service.dart';
import 'package:mescidgo/features/home/presentation/screens/home_screen.dart';
import 'package:mescidgo/features/settings/presentation/screens/settings_screen.dart';
import 'package:mescidgo/features/splash/presentation/splash_screen.dart';
import 'package:mescidgo/features/userPrayerTimes/presentation/screens/user_prayer_times_screen.dart';
import 'package:mescidgo/services/prayer_time_buttons.dart';
import 'package:mescidgo/services/prayer_times.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await initializeDateFormatting('tr', null);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<PrayerTimeChecker>(create: (_) => PrayerTimeChecker()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<PrayerTimeService>(
            create: (_) => PrayerTimeService()), // Add this line
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return MaterialApp(
      title: 'Flutter Pray App',
      theme: _buildTheme(),
      home: AuthWrapper(),
      routes: _buildRoutes(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/home': (context) => HomeScreen(),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/settings': (context) => SettingsScreen(),
      '/user-prayer-times': (context) => UserPrayerTimesScreen(),
      // Add other routes here
    };
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
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
