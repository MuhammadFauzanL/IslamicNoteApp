import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerService {
  static Future<Map<String, String>> fetchPrayerTimes() async {
    final response = await http.get(
      Uri.parse(
        'https://api.aladhan.com/v1/timingsByCity?city=Jakarta&country=Indonesia&method=2',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat jadwal sholat');
    }

    final data = json.decode(response.body);
    final timings = data['data']['timings'];

    return {
      'Subuh': timings['Fajr'],
      'Dzuhur': timings['Dhuhr'],
      'Ashar': timings['Asr'],
      'Maghrib': timings['Maghrib'],
      'Isya': timings['Isha'],
    };
  }
}
