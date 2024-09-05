import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/constants/styles.dart';
import 'package:mescidgo/core/services/permission_service.dart';
import 'package:mescidgo/core/utils/navigation.dart';
import 'package:mescidgo/core/widgets/custom_app_bar.dart';
import 'package:mescidgo/features/auth/presentation/widgets/auth_service.dart';
import 'package:package_info/package_info.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final PermissionService _permissionService = PermissionService();
  String _appVersion = '';
  bool _locationPermissionEnabled = false;
  bool _notificationPermissionEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _requestLocationPermission() async {
    try {
      await _permissionService.requestLocationPermission();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission error: $e')),
      );
    }
  }

  Future<void> _requestNotificationPermission() async {
    try {
      await _permissionService.requestNotificationPermission();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification permission error: $e')),
      );
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _authService.signOut();
      NavigationUtil.replaceWithNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $e')),
      );
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SwitchListTile(
                  title: Text('Enable Location Permission'),
                  value: _locationPermissionEnabled,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (bool value) {
                    setState(() {
                      _locationPermissionEnabled = value;
                    });
                    if (value) {
                      _requestLocationPermission();
                    }
                  },
                ),
                SwitchListTile(
                  title: Text('Enable Notification Permission'),
                  value: _notificationPermissionEnabled,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationPermissionEnabled = value;
                    });
                    if (value) {
                      _requestNotificationPermission();
                    }
                  },
                ),
                SizedBox(height: 40),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                    style:
                        Styles.bodyTextStyle.copyWith(color: AppColors.white),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'App Version: $_appVersion',
                    style: Styles.bodyTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
