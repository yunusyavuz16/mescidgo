import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/constants/styles.dart';
import 'package:mescidgo/features/home/presentation/widgets/dashed_line.dart';
import 'package:mescidgo/models/prayer_times.dart';
import 'package:mescidgo/services/prayer_times.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<PrayerTimes> futurePrayerTimes;

  @override
  void initState() {
    super.initState();
    futurePrayerTimes = ApiService().fetchPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mescid Go', style: Styles.titleTextStyle),
        backgroundColor: AppColors.primaryGreen,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      body: FutureBuilder<PrayerTimes>(
        future: futurePrayerTimes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }
          // {tarih: 2024-08-29, imsak: [{tarih: 2024-08-29T01:33:00Z, is_takdiri: false}], israk: [], sabah: [{tarih: 2024-08-29T01:53:00Z, is_takdiri: false}], gunes: [{tarih: 2024-08-29T03:20:00Z, is_takdiri: false}], ogle: [{tarih: 2024-08-29T10:15:00Z, is_takdiri: false}], ikindi: [{tarih: 2024-08-29T13:57:00Z, is_takdiri: false}], aksam: [{tarih: 2024-08-29T16:49:00Z, is_takdiri: false}], yatsi: [{tarih: 2024-08-29T18:23:00Z, is_takdiri: false}]}
          // above data is snapshot.data changing it to PrayerTimes object

          final prayerTimes = snapshot.data;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: AppColors.primaryGreen,
                height: 100,
                width: double.infinity,
              ),
              Positioned(
                top: 25,
                left: 0,
                right: 0,
                child: Padding(
                  padding: Styles.screenPadding,
                  child: Container(
                    height: 200, // Increased height to fit all the times
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
                    child: Column(
                      children: [
                        // Upper part with location and current prayer time
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left side: Location
                              Text(
                                'Istanbul',
                                style: Styles.subtitleTextStyle,
                              ),
                              // Right side: Current prayer time
                              Text(
                                'Öğle', // You can dynamically set this based on current time
                                style: Styles.subtitleTextStyle,
                              ),
                            ],
                          ),
                        ),
                        // Dashed green border
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          child: DashedLine(
                            color: AppColors.primaryGreen,
                            height: 1,
                            width: double.infinity,
                          ),
                        ),
                        // Lower part: Prayer times
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GridView.count(
                              crossAxisCount: 3, // 3 items per row
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              childAspectRatio:
                                  3, // Adjust this to control the width/height ratio
                              children: [
                                Text('İmsak: ${prayerTimes?.imsak ?? ""}',
                                    style: Styles.buttonTextStyle),
                                Text('Sabah: ${prayerTimes?.sabah ?? ""}',
                                    style: Styles.buttonTextStyle),
                                Text('Güneş: ${prayerTimes?.gunes ?? ""}',
                                    style: Styles.buttonTextStyle),
                                Text('Öğle: ${prayerTimes?.ogle ?? ""}',
                                    style: Styles.buttonTextStyle),
                                Text('İkindi: ${prayerTimes?.ikindi}',
                                    style: Styles.buttonTextStyle),
                                Text('Akşam: ${prayerTimes?.aksam}',
                                    style: Styles.buttonTextStyle),
                                Text('Yatsı: ${prayerTimes?.yatsi}',
                                    style: Styles.buttonTextStyle),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
