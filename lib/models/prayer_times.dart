import 'package:intl/intl.dart';
import 'package:mescidgo/core/constants/prayer_times_enum.dart';

class PrayerTimes {
  final String imsak;
  final String sabah;
  final String gunes;
  final String ogle;
  final String ikindi;
  final String aksam;
  final String yatsi;

  PrayerTimes({
    required this.imsak,
    required this.sabah,
    required this.gunes,
    required this.ogle,
    required this.ikindi,
    required this.aksam,
    required this.yatsi,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    String parseTime(List<dynamic> list) {
      if (list.isNotEmpty) {
        final timeString = list[0]['tarih'] as String;
        return _adjustTime(timeString);
      }
      return '00:00';
    }

    return PrayerTimes(
      imsak: parseTime(json['imsak'] as List),
      sabah: parseTime(json['sabah'] as List),
      gunes: parseTime(json['gunes'] as List),
      ogle: parseTime(json['ogle'] as List),
      ikindi: parseTime(json['ikindi'] as List),
      aksam: parseTime(json['aksam'] as List),
      yatsi: parseTime(json['yatsi'] as List),
    );
  }

  static String _adjustTime(String timeString) {
    final dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
    final adjustedFormat = DateFormat("HH:mm");

    // Parse the input time
    final dateTime = dateFormat.parse(timeString, true).add(Duration(hours: 3));

    // Format and return the adjusted time
    return adjustedFormat.format(dateTime);
  }

  String getTime(PrayerTime prayerTime) {
    switch (prayerTime) {
      case PrayerTime.imsak:
        return imsak;
      case PrayerTime.sabah:
        return sabah;
      case PrayerTime.gunes:
        return gunes;
      case PrayerTime.ogle:
        return ogle;
      case PrayerTime.ikindi:
        return ikindi;
      case PrayerTime.aksam:
        return aksam;
      case PrayerTime.yatsi:
        return yatsi;
    }
  }
}
