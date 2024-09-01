import 'package:intl/intl.dart';
import 'package:mescidgo/models/prayer_times.dart';
import 'package:mescidgo/core/constants/prayer_times_enum.dart';

class PrayerTimeChecker {
  bool isCurrentPrayerTime(PrayerTimes prayerTimes, PrayerTime prayerTime) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(now);

    int nowTime = int.parse(formattedTime.replaceAll(':', ''));
    int currentPrayerTime = _getPrayerTime(prayerTimes, prayerTime);

    return nowTime >= currentPrayerTime &&
        nowTime < _getNextPrayerTime(prayerTimes, prayerTime);
  }

  int _getPrayerTime(PrayerTimes prayerTimes, PrayerTime prayerTime) {
    switch (prayerTime) {
      case PrayerTime.imsak:
        return int.parse(prayerTimes.imsak.replaceAll(':', ''));
      case PrayerTime.sabah:
        return int.parse(prayerTimes.sabah.replaceAll(':', ''));
      case PrayerTime.gunes:
        return int.parse(prayerTimes.gunes.replaceAll(':', ''));
      case PrayerTime.ogle:
        return int.parse(prayerTimes.ogle.replaceAll(':', ''));
      case PrayerTime.ikindi:
        return int.parse(prayerTimes.ikindi.replaceAll(':', ''));
      case PrayerTime.aksam:
        return int.parse(prayerTimes.aksam.replaceAll(':', ''));
      case PrayerTime.yatsi:
        return int.parse(prayerTimes.yatsi.replaceAll(':', ''));
      default:
        return 0;
    }
  }

  PrayerTime _getNextPrayerEnum(PrayerTime currentPrayer) {
    switch (currentPrayer) {
      case PrayerTime.imsak:
        return PrayerTime.sabah;
      case PrayerTime.sabah:
        return PrayerTime.gunes;
      case PrayerTime.gunes:
        return PrayerTime.ogle;
      case PrayerTime.ogle:
        return PrayerTime.ikindi;
      case PrayerTime.ikindi:
        return PrayerTime.aksam;
      case PrayerTime.aksam:
        return PrayerTime.yatsi;
      case PrayerTime.yatsi:
        return PrayerTime.imsak;
      default:
        return PrayerTime.imsak;
    }
  }

  int _getNextPrayerTime(PrayerTimes prayerTimes, PrayerTime prayerTime) {
    PrayerTime nextPrayer = _getNextPrayerEnum(prayerTime);
    return _getPrayerTime(prayerTimes, nextPrayer);
  }
}
