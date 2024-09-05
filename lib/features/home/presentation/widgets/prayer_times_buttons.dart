import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/constants/prayer_times_enum.dart';
import 'package:mescidgo/core/constants/styles.dart';
import 'package:mescidgo/features/home/presentation/widgets/dashed_line.dart';
import 'package:mescidgo/services/prayer_time_buttons.dart';
import 'package:provider/provider.dart';
import 'package:mescidgo/core/widgets/snackbar_helper.dart';

class PrayerTimesButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.screenPadding,
      child: Container(
        margin: EdgeInsets.only(top: 260),
        height: 225,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kılınan Vakitler',
                    style: Styles.subtitleTextStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/user-prayer-times');
                    },
                    child: Row(
                      children: [
                        Text(
                          'Tümünü Gör',
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              DashedLine(color: AppColors.primaryGreen, height: 1),
              SizedBox(height: 10),
              FutureBuilder(
                future: Provider.of<PrayerTimeService>(context, listen: false)
                    .checkAndCreatePrayerTimes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryGreen));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return StreamBuilder<DatabaseEvent>(
                      stream: FirebaseDatabase.instance
                          .ref()
                          .child('users')
                          .child(FirebaseAuth.instance.currentUser?.uid ?? '')
                          .child('prayer_times')
                          .child(DateTime.now().toIso8601String().split('T')[0])
                          .onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.darkGreen));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data?.snapshot.value == null) {
                          return Center(child: Text('No data available'));
                        }

                        final data = (snapshot.data!.snapshot.value
                                as Map<dynamic, dynamic>?) ??
                            {};

                        return Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.0,
                            crossAxisSpacing: 12.0,
                            childAspectRatio: 4,
                            children: [
                              _buildPrayerButton(
                                  context,
                                  PrayerTime.sabah.label,
                                  data['sabah'],
                                  'sabah',
                                  Icons.brightness_5),
                              _buildPrayerButton(context, PrayerTime.ogle.label,
                                  data['ogle'], 'ogle', Icons.wb_sunny),
                              _buildPrayerButton(
                                  context,
                                  PrayerTime.ikindi.label,
                                  data['ikindi'],
                                  'ikindi',
                                  Icons.wb_cloudy),
                              _buildPrayerButton(
                                  context,
                                  PrayerTime.aksam.label,
                                  data['aksam'],
                                  'aksam',
                                  Icons.nightlight_round),
                              _buildPrayerButton(
                                  context,
                                  PrayerTime.yatsi.label,
                                  data['yatsi'],
                                  'yatsi',
                                  Icons.bedtime),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerButton(BuildContext context, String timeName,
      bool? isPrayed, String timeKey, IconData icon) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          bool newStatus = !(isPrayed ?? false);
          Provider.of<PrayerTimeService>(context, listen: false)
              .updatePrayerTime(timeKey, newStatus);
          SnackbarHelper.showSnackbar(context, 'Kaydedildi');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrayed == true ? AppColors.primaryGreen : AppColors.white,
          foregroundColor:
              isPrayed == true ? Colors.white : Colors.black.withOpacity(0.7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 12),
            Text(timeName),
          ],
        ),
      ),
    );
  }
}
