import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
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
        prayerTimes[dayString]![prayerName] = !prayerTimes[dayString]![prayerName]!;
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
    final lastDayOfMonth = DateTime(firstDayOfMonth.year, firstDayOfMonth.month + 1, 0);
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
                  _markDayAsPrayed(selectedDay);
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final isPrayed = prayerTimes[_dateTimeToString(day)]
                      ?.values
                      .every((e) => e) ??
                      false;
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isPrayed ? AppColors.primaryGreen : null,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: isPrayed ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _markMonthAsPrayed(DateTime(_focusedDay.year, _focusedDay.month, 1));
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
