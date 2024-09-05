import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PrayerTimeService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkAndCreatePrayerTimes() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      String userId = user.uid;
      DateTime today = DateTime.now();
      String todayDateKey = today.toIso8601String().split('T')[0];

      DatabaseReference userPrayerTimesRef = _database
          .ref()
          .child('users')
          .child(userId)
          .child('prayer_times')
          .child(todayDateKey);

      DatabaseEvent event = await userPrayerTimesRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (!snapshot.exists) {
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

  Future<void> updatePrayerTime(String timeKey, bool isPrayed) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      DateTime today = DateTime.now();
      String todayDateKey = today.toIso8601String().split('T')[0];

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
}
