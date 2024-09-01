import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/constants/prayer_times_enum.dart';
import 'package:mescidgo/core/constants/styles.dart';
import 'package:mescidgo/features/home/presentation/widgets/dashed_line.dart';
import 'package:mescidgo/features/userPrayerTimes/presentation/screens/user_prayer_times_screen.dart';

class PrayerTimesButtons extends StatelessWidget {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _checkAndCreatePrayerTimes() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      String userId = user.uid;
      DateTime today = DateTime.now();
      String todayDateKey = today
          .toIso8601String()
          .split('T')[0]; // YYYY-MM-DD formatında anahtar

      DatabaseReference userPrayerTimesRef = _database
          .ref()
          .child('users')
          .child(userId)
          .child('prayer_times')
          .child(todayDateKey);

      DatabaseEvent event = await userPrayerTimesRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (!snapshot.exists) {
        // Eğer veri yoksa, default değerlerle oluştur
        await userPrayerTimesRef.set({
          'sabah': false,
          'ogle': false,
          'ikindi': false,
          'aksam': false,
          'yatsi': false,
        });
      }
    } catch (e) {
      print('Error checking or creating prayer times: $e');
    }
  }

  Future<void> _updatePrayerTime(String timeKey, bool isPrayed) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      DateTime today = DateTime.now();
      String todayDateKey = today
          .toIso8601String()
          .split('T')[0]; // YYYY-MM-DD formatında anahtar

      DatabaseReference userPrayerTimesRef = _database
          .ref()
          .child('users')
          .child(user.uid)
          .child('prayer_times')
          .child(todayDateKey);

      await userPrayerTimesRef.update({timeKey: isPrayed});
    } catch (e) {
      print('Error updating prayer time: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String todayDateKey =
        today.toIso8601String().split('T')[0]; // YYYY-MM-DD formatında anahtar

    return Padding(
      padding: Styles.screenPadding,
      child: Container(
        margin: EdgeInsets.only(top: 260),
        height: 225, // Yüksekliği artırarak başlık için yer açıyoruz
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
          // vertical 8 horizontal 12
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kılınan Vakitler', // Başlık
                    style: Styles.subtitleTextStyle,
                    // Başlık stili
                  ),
                  TextButton(
                      onPressed: () {
                         Navigator.pushNamed(context, '/user-prayer-times');
                      },
                      child: Row(
                        children: [
                          Text(
                            '',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              DashedLine(
                  color: AppColors.primaryGreen,
                  height: 1), // Başlık altına çizgi ekliyoruz
              SizedBox(
                  height:
                      10), // Başlık ile butonlar arasında boşluk bırakıyoruz
              FutureBuilder(
                future: _checkAndCreatePrayerTimes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: AppColors.primaryGreen,));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return StreamBuilder<DatabaseEvent>(
                      stream: _database
                          .ref()
                          .child('users')
                          .child(FirebaseAuth.instance.currentUser?.uid ?? '')
                          .child('prayer_times')
                          .child(todayDateKey)
                          .onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: AppColors.darkGreen,));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.snapshot.value == null) {
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
                              _buildPrayerButton(PrayerTime.sabah.label,
                                  data['sabah'], 'sabah', Icons.brightness_5),
                              _buildPrayerButton(PrayerTime.ogle.label,
                                  data['ogle'], 'ogle', Icons.wb_sunny),
                              _buildPrayerButton(PrayerTime.ikindi.label,
                                  data['ikindi'], 'ikindi', Icons.wb_cloudy),
                              _buildPrayerButton(
                                  PrayerTime.aksam.label,
                                  data['aksam'],
                                  'aksam',
                                  Icons.nightlight_round),
                              _buildPrayerButton(PrayerTime.yatsi.label,
                                  data['yatsi'], 'yatsi', Icons.bedtime),
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

  Widget _buildPrayerButton(
      String timeName, bool? isPrayed, String timeKey, IconData icon) {
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
          // Toggle the prayer time state
          bool newStatus = !(isPrayed ?? false);
          _updatePrayerTime(timeKey, newStatus);
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
            SizedBox(width: 12), // İkon ile metin arasına boşluk ekliyoruz
            Text(timeName),
          ],
        ),
      ),
    );
  }
}
