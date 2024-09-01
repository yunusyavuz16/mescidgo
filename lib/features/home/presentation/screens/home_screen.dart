import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/constants/prayer_times_enum.dart';
import 'package:mescidgo/core/constants/styles.dart';
import 'package:mescidgo/core/utils/prayer_time_checker.dart';
import 'package:mescidgo/features/home/presentation/widgets/dashed_line.dart';
import 'package:mescidgo/features/home/presentation/widgets/prayer_time_item.dart';
import 'package:mescidgo/features/home/presentation/widgets/prayer_times_buttons.dart';
import 'package:mescidgo/models/prayer_times.dart';
import 'package:mescidgo/services/prayer_times.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<PrayerTimes> futurePrayerTimes;
  final PrayerTimeChecker prayerTimeChecker = PrayerTimeChecker();

  @override
  void initState() {
    super.initState();
    futurePrayerTimes = ApiService().fetchPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM', 'tr').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mescid Go', style: Styles.titleTextStyle),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
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
                    height: 220,
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
                        Padding(
                          padding: Styles.screenPadding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'İstanbul',
                                style: Styles.subtitleTextStyle,
                              ),
                              Text(
                                formattedDate,
                                style: Styles.subtitleTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          child: DashedLine(
                            color: AppColors.primaryGreen,
                            height: 1,
                            width: double.infinity,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: Styles.screenPadding,
                            child: GridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 2.5,
                              children: [
                                PrayerTimeItem(
                                  timeName: PrayerTime.imsak.label,
                                  time: prayerTimes?.imsak ?? "",
                                  isCurrent:
                                      prayerTimeChecker.isCurrentPrayerTime(
                                          prayerTimes!, PrayerTime.imsak),
                                ),
                                PrayerTimeItem(
                                  timeName: PrayerTime.sabah.label,
                                  time: prayerTimes?.sabah ?? "",
                                  isCurrent:
                                      prayerTimeChecker.isCurrentPrayerTime(
                                          prayerTimes, PrayerTime.sabah),
                                ),
                                PrayerTimeItem(
                                  timeName: PrayerTime.gunes.label,
                                  time: prayerTimes?.gunes ?? "",
                                  isCurrent:
                                      prayerTimeChecker.isCurrentPrayerTime(
                                          prayerTimes, PrayerTime.gunes),
                                ),
                                PrayerTimeItem(
                                  timeName: PrayerTime.ogle.label,
                                  time: prayerTimes?.ogle ?? "",
                                  isCurrent:
                                      prayerTimeChecker.isCurrentPrayerTime(
                                          prayerTimes, PrayerTime.ogle),
                                ),
                                PrayerTimeItem(
                                  timeName: PrayerTime.ikindi.label,
                                  time: prayerTimes?.ikindi ?? "",
                                  isCurrent:
                                      prayerTimeChecker.isCurrentPrayerTime(
                                          prayerTimes, PrayerTime.ikindi),
                                ),
                                PrayerTimeItem(
                                  timeName: PrayerTime.aksam.label,
                                  time: prayerTimes?.aksam ?? "",
                                  isCurrent:
                                      prayerTimeChecker.isCurrentPrayerTime(
                                          prayerTimes, PrayerTime.aksam),
                                ),
                                PrayerTimeItem(
                                  timeName: PrayerTime.yatsi.label,
                                  time: prayerTimes?.yatsi ?? "",
                                  isCurrent:
                                      prayerTimeChecker.isCurrentPrayerTime(
                                          prayerTimes, PrayerTime.yatsi),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PrayerTimesButtons(), // Yeni widget'ı burada kullanın
            ],
          );
        },
      ),
    );
  }
}
