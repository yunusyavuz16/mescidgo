import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/constants/styles.dart';

class PrayerTimeItem extends StatelessWidget {
  final String timeName;
  final String time;
  final bool isCurrent;

  const PrayerTimeItem({
    Key? key,
    required this.timeName,
    required this.time,
    required this.isCurrent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0), // Padding
      margin: EdgeInsets.symmetric(vertical: 6.0), // Margin
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primaryGreen : AppColors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      constraints: BoxConstraints(
        minHeight: 80.0, // Minimum yükseklik artırıldı
      ),
      child: Center(
        child: Text(
          '$timeName: $time',
          style: isCurrent ? Styles.successTextStyleSmall : Styles.buttonTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}