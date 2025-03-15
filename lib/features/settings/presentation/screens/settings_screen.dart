import 'package:flutter/material.dart';
import 'package:mescid_go/core/constants/colors.dart';
import 'package:mescid_go/core/utils/navigation.dart';
import 'package:mescid_go/core/widgets/custom_app_bar.dart';
import 'package:mescid_go/features/auth/presentation/widgets/auth_service.dart';
import 'package:mescid_go/features/auth/presentation/widgets/custom_button.dart';
import 'package:mescid_go/features/settings/presentation/widgets/language_switch.dart';
import 'package:mescid_go/l10n/app_localizations.dart';
import 'package:mescid_go/l10n/locale_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isTurkish = false;
  bool _locationPermissionGranted = false;
  bool _notificationPermissionGranted = false;
  String _appVersion = "";
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _checkPermissions();
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _checkPermissions() async {
    _locationPermissionGranted = await Permission.location.isGranted;
    _notificationPermissionGranted = await Permission.notification.isGranted;
    setState(() {});
  }

  void _toggleLanguage(bool isTurkish) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    setState(() {
      _isTurkish = isTurkish;
      localeProvider.setLocale(Locale(isTurkish ? 'tr' : 'en'));
    });
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    setState(() {
      _locationPermissionGranted = status.isGranted;
    });
  }

  Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    setState(() {
      _notificationPermissionGranted = status.isGranted;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    await _authService.signOut();
    NavigationUtil.replaceWithNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).translate('settingsTitle'),
        showBackButton: true,
        titleCentered: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate('locationPermission'),
                  style: TextStyle(fontSize: 18),
                ),
                Switch(
                  value: _locationPermissionGranted,
                  onChanged: (bool value) async {
                    if (!value) {
                      await _requestLocationPermission();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate('notificationPermission'),
                  style: TextStyle(fontSize: 18),
                ),
                Switch(
                  value: _notificationPermissionGranted,
                  onChanged: (bool value) async {
                    if (!value) {
                      await _requestNotificationPermission();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LanguageSwitch(
                  isTurkish: _isTurkish,
                  onToggle: _toggleLanguage,
                ),
              ],
            ),
            SizedBox(height: 40),
            CustomButton(
              onPressed: () => _signOut(context),
              text: AppLocalizations.of(context).translate('signOut'),
              borderColors: AppColors.primaryRed,
              backgroundColor: AppColors.nearWhite,
              textColor: AppColors.primaryRed,
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                '${AppLocalizations.of(context).translate('appVersion')}: $_appVersion',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}