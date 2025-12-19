import 'package:flutter/material.dart';
import '../../../core/services/prayer_service.dart';

class HomeController {
  Map<String, String> prayerTimes = {};

  Future<void> loadPrayerTimes() async {
    prayerTimes = await PrayerService.fetchPrayerTimes();
  }

  String getNextPrayer() {
    final now = TimeOfDay.now();

    TimeOfDay toTime(String time) {
      final parts = time.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    for (final name in prayerTimes.keys) {
      final t = toTime(prayerTimes[name]!);
      if (t.hour > now.hour || (t.hour == now.hour && t.minute > now.minute)) {
        return name;
      }
    }

    return 'Subuh';
  }
}
