import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_URL']!;

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
