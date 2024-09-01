// lib/core/constants/prayer_times_enum.dart

enum PrayerTime {
  imsak,
  sabah,
  gunes,
  ogle,
  ikindi,
  aksam,
  yatsi,
}

extension PrayerTimeExtension on PrayerTime {
  String get label {
    switch (this) {
      case PrayerTime.imsak:
        return 'İmsak';
      case PrayerTime.sabah:
        return 'Sabah';
      case PrayerTime.gunes:
        return 'Güneş';
      case PrayerTime.ogle:
        return 'Öğle';
      case PrayerTime.ikindi:
        return 'İkindi';
      case PrayerTime.aksam:
        return 'Akşam';
      case PrayerTime.yatsi:
        return 'Yatsı';
      default:
        return '';
    }
  }
}
