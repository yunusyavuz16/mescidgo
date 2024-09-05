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
import 'package:provider/provider.dart'; // Provider için gerekli import

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    final prayerTimeChecker = Provider.of<PrayerTimeChecker>(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, apiService, prayerTimeChecker),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  Widget _buildBody(BuildContext context, ApiService apiService, PrayerTimeChecker prayerTimeChecker) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM', 'tr').format(now);

    return FutureBuilder<PrayerTimes>(
      future: apiService.fetchPrayerTimes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryGreen),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }

        final prayerTimes = snapshot.data!;
        return _buildPrayerTimesContent(prayerTimes, formattedDate, prayerTimeChecker);
      },
    );
  }

  Widget _buildPrayerTimesContent(PrayerTimes prayerTimes, String formattedDate, PrayerTimeChecker prayerTimeChecker) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildBackground(),
        _buildPrayerTimesCard(prayerTimes, formattedDate, prayerTimeChecker),
        PrayerTimesButtons(),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      color: AppColors.primaryGreen,
      height: 100,
      width: double.infinity,
    );
  }

  Widget _buildPrayerTimesCard(PrayerTimes prayerTimes, String formattedDate, PrayerTimeChecker prayerTimeChecker) {
    return Positioned(
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
              _buildHeader(formattedDate),
              _buildDashedLine(),
              _buildPrayerTimesGrid(prayerTimes, prayerTimeChecker),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String formattedDate) {
    return Padding(
      padding: Styles.screenPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('İstanbul', style: Styles.subtitleTextStyle),
          Text(formattedDate, style: Styles.subtitleTextStyle),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: DashedLine(
        color: AppColors.primaryGreen,
        height: 1,
        width: double.infinity,
      ),
    );
  }

  Widget _buildPrayerTimesGrid(PrayerTimes prayerTimes, PrayerTimeChecker prayerTimeChecker) {
    return Expanded(
      child: Padding(
        padding: Styles.screenPadding,
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 2.5,
          children: PrayerTime.values.map((prayerTime) {
            return PrayerTimeItem(
              timeName: prayerTime.label,
              time: prayerTimes.getTime(prayerTime),
              isCurrent: prayerTimeChecker.isCurrentPrayerTime(prayerTimes, prayerTime),
            );
          }).toList(),
        ),
      ),
    );
  }
}
