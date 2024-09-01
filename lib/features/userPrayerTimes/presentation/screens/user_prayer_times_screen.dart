import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/constants/prayer_times_enum.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mescidgo/core/widgets/custom_app_bar.dart';

class UserPrayerTimesScreen extends StatefulWidget {
  @override
  _UserPrayerTimesScreenState createState() => _UserPrayerTimesScreenState();
}

class _UserPrayerTimesScreenState extends State<UserPrayerTimesScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<String, Map<String, bool>> prayerTimes = {};

  DateTime _stringToDateTime(String dateString) {
    return DateTime.parse(dateString);
  }

  String _dateTimeToString(DateTime dateTime) {
    return dateTime.toIso8601String().split('T').first;
  }

  void _togglePrayerTime(DateTime day, String prayerName) {
    String dayString = _dateTimeToString(day);
    setState(() {
      if (prayerTimes.containsKey(dayString)) {
        prayerTimes[dayString]![prayerName] =
            !prayerTimes[dayString]![prayerName]!;
      } else {
        prayerTimes[dayString] = {
          'sabah': false,
          'ogle': false,
          'ikindi': false,
          'aksam': false,
          'yatsi': false,
        };
        prayerTimes[dayString]![prayerName] = true;
      }
    });
  }

  void _markDayAsPrayed(DateTime day) {
    String dayString = _dateTimeToString(day);
    setState(() {
      prayerTimes[dayString] = {
        'sabah': true,
        'ogle': true,
        'ikindi': true,
        'aksam': true,
        'yatsi': true,
      };
    });
  }

  void _markMonthAsPrayed(DateTime firstDayOfMonth) {
    final lastDayOfMonth =
        DateTime(firstDayOfMonth.year, firstDayOfMonth.month + 1, 0);
    setState(() {
      for (DateTime day = firstDayOfMonth;
          day.isBefore(lastDayOfMonth) || day.isAtSameMomentAs(lastDayOfMonth);
          day = day.add(Duration(days: 1))) {
        _markDayAsPrayed(day);
      }
    });
  }

  void _markYearAsPrayed(DateTime firstDayOfYear) {
    final lastDayOfYear = DateTime(firstDayOfYear.year + 1, 1, 0);
    setState(() {
      for (DateTime day = firstDayOfYear;
          day.isBefore(lastDayOfYear) || day.isAtSameMomentAs(lastDayOfYear);
          day = day.add(Duration(days: 1))) {
        _markDayAsPrayed(day);
      }
    });
  }

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
            TableCalendar(
              locale: 'tr_TR', // Takvimi Türkçeye çevirir
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  final prayersForDay = prayerTimes[_dateTimeToString(day)];
                  if (prayersForDay == null) return SizedBox.shrink();

                  bool allPrayed = prayersForDay.values.every((e) => e);
                  bool nonePrayed = prayersForDay.values.every((e) => !e);

                  if (allPrayed || nonePrayed) return SizedBox.shrink();

                  List<Widget> markers = [];

                  for (String prayer in [
                    'sabah',
                    'ogle',
                    'ikindi',
                    'aksam',
                    'yatsi'
                  ]) {
                    markers.add(
                      Icon(
                        Icons.circle,
                        size: 8.0,
                        color: prayersForDay[prayer]!
                            ? AppColors.primaryGreen
                            : Colors.red,
                      ),
                    );
                  }

                  return Positioned(
                    bottom: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: markers,
                    ),
                  );
                },
                defaultBuilder: (context, day, focusedDay) {
                  final prayersForDay = prayerTimes[_dateTimeToString(day)];
                  Color? bgColor;
                  if (prayersForDay != null) {
                    bool allPrayed = prayersForDay.values.every((e) => e);
                    bool nonePrayed = prayersForDay.values.every((e) => !e);

                    if (allPrayed) {
                      bgColor = AppColors.primaryGreen;
                    } else if (nonePrayed) {
                      bgColor = Colors.red;
                    } else {
                      bgColor = Colors.white; // Some prayed, some not
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: bgColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_selectedDay != null) ...[
              const SizedBox(height: 20),
              Text(
                'Vakitleri İşaretle (${
                // format dd MMM YYYYY
                '${_selectedDay!.day}-${_selectedDay!.month}-${_selectedDay!.year}'})',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10.0,
                children: [
                  PrayerTime.sabah.name,
                  PrayerTime.ogle.name,
                  PrayerTime.ikindi.name,
                  PrayerTime.aksam.name,
                  PrayerTime.yatsi.name
                ]
                    .map((prayer) => ElevatedButton(
                          onPressed: () {
                            _togglePrayerTime(_selectedDay!, prayer);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                prayerTimes[_dateTimeToString(_selectedDay!)]
                                            ?[prayer] ==
                                        true
                                    ? AppColors.primaryGreen
                                    : Colors.red,
                          ),
                          child: Text(prayer,
                              style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: () {
                if (_selectedDay != null) {
                  _markDayAsPrayed(_selectedDay!);
                }
              },
              child: Text('Bu Günün Tüm Vakitlerini İşaretle'),
            ),
            ElevatedButton(
              onPressed: () {
                _markMonthAsPrayed(
                    DateTime(_focusedDay.year, _focusedDay.month, 1));
              },
              child: Text('Bu Ayın Tüm Vakitlerini İşaretle'),
            ),
            ElevatedButton(
              onPressed: () {
                _markYearAsPrayed(DateTime(_focusedDay.year, 1, 1));
              },
              child: Text('Bu Yılın Tüm Vakitlerini İşaretle'),
            ),
          ],
        ),
      ),
    );
  }
}
