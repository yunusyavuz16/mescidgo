import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/styles.dart';
import 'package:mescidgo/core/widgets/custom_app_bar.dart';

class UserPrayerTimesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Tüm Namazlar', showBackButton: true, titleCentered: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tüm Namazlar',
              style: Styles.titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
