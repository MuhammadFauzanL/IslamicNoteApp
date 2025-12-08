import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> schedulePrayerNotification(String title, String body, DateTime scheduledTime) async {
  final now = DateTime.now();
  var scheduledDate = scheduledTime.isBefore(now) ? scheduledTime.add(Duration(days: 1)) : scheduledTime;

  await flutterLocalNotificationsPlugin.zonedSchedule(
    title.hashCode,
    title,
    body,
    tz.TZDateTime.from(scheduledDate, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_channel',
        'Prayer Notifications',
        channelDescription: 'Reminder notifications for prayer times',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> scheduleAllPrayerNotifications() async {
  final now = DateTime.now();

  final prayers = {
    'Subuh': DateTime(now.year, now.month, now.day, 4, 30),
    'Dzuhur': DateTime(now.year, now.month, now.day, 12, 0),
    'Ashar': DateTime(now.year, now.month, now.day, 15, 0),
    'Maghrib': DateTime(now.year, now.month, now.day, 18, 0),
    'Isya': DateTime(now.year, now.month, now.day, 19, 30),
  };

  for (var entry in prayers.entries) {
    await schedulePrayerNotification(
      'Waktu Sholat ${entry.key}',
      'Saatnya sholat ${entry.key}, jangan lupa!',
      entry.value,
    );
  }
}
