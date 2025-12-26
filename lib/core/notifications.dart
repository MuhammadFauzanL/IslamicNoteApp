import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> schedulePrayerNotification({
  required int id,
  required String title,
  required String body,
  required tz.TZDateTime scheduledDate,
}) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_channel_id',
        'Prayer Notifications',
        channelDescription: 'Channel untuk notifikasi pengingat sholat',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> scheduleAllPrayerNotifications() async {
  final now = tz.TZDateTime.now(tz.local);

  final prayers = {
    'Subuh': tz.TZDateTime(tz.local, now.year, now.month, now.day, 4, 30),
    'Dzuhur': tz.TZDateTime(tz.local, now.year, now.month, now.day, 12, 0),
    'Ashar': tz.TZDateTime(tz.local, now.year, now.month, now.day, 15, 0),
    'Maghrib': tz.TZDateTime(tz.local, now.year, now.month, now.day, 18, 0),
    'Isya': tz.TZDateTime(tz.local, now.year, now.month, now.day, 19, 30),
  };

  int id = 0;
  for (final prayer in prayers.entries) {
    tz.TZDateTime scheduledTime = prayer.value;

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await schedulePrayerNotification(
      id: id,
      title: 'Pengingat Sholat',
      body: 'Waktunya sholat ${prayer.key}',
      scheduledDate: scheduledTime,
    );
    id++;
  }
}

Future<void> showPrayerReminderNotification(String prayerName) async {
  await flutterLocalNotificationsPlugin.show(
    999,
    'Tes Notifikasi Sholat',
    'Waktunya sholat $prayerName',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_channel_id',
        'Prayer Notifications',
        channelDescription: 'Channel untuk notifikasi pengingat sholat',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}
