import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';

class ApiService {
  final String baseUrl = 'https://fazilettakvimi.com/api/cms/daily?districtId=31&lang=1';

  Future<PrayerTimes> fetchPrayerTimes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // logging data
      print(data['vakitler'][0]);

      // Assuming the API response format, adjust as needed
      return PrayerTimes.fromJson(data['vakitler'][0]);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
