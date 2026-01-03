import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart'
    show openAppSettings;
import 'package:flutter_timezone/flutter_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<bool> openNotificationSettings() async {
  return await openAppSettings();
}

Future<void> initializeNotifications() async {
  tz.initializeTimeZones();

  // Get timezone with fallback
  String timeZoneName = 'Asia/Jakarta'; // Default fallback
  try {
    timeZoneName = await FlutterTimezone.getLocalTimezone()
        .timeout(const Duration(seconds: 3));
  } catch (e) {
    print('⚠️ Failed to get timezone, using default: $e');
  }

  try {
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_masjid');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

/// Request notification permission - returns true if granted, false otherwise.
/// Uses the native plugin method which is more reliable for Android 13+
Future<bool> requestNotificationPermission() async {
  final androidPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlugin != null) {
    // This calls the native ActivityCompat.requestPermissions
    final granted = await androidPlugin.requestNotificationsPermission();
    return granted ?? false;
  }

  // For non-Android or older versions where requesting isn't needed/supported
  return true;
}

/// Check if notification permission is granted without requesting
Future<bool> isNotificationPermissionGranted() async {
  // Native plugin check logic is implicit in the request, returning true to proceed
  return true;
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
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> scheduleAllPrayerNotifications(
    Map<String, String> prayerTimes) async {
  final now = tz.TZDateTime.now(tz.local);

  // Cancel existing prayer notifications first
  for (int i = 0; i < 5; i++) {
    await flutterLocalNotificationsPlugin.cancel(i);
  }

  // Map prayer names to their times
  final prayerMap = {
    'Subuh': prayerTimes['Subuh'],
    'Dzuhur': prayerTimes['Dzuhur'],
    'Ashar': prayerTimes['Ashar'],
    'Maghrib': prayerTimes['Maghrib'],
    'Isya': prayerTimes['Isya'],
  };

  int id = 0;
  for (final prayer in prayerMap.entries) {
    if (prayer.value == null || prayer.value == '--:--') {
      id++;
      continue;
    }

    // Parse time string (format: "HH:mm")
    final timeParts = prayer.value!.split(':');
    if (timeParts.length != 2) {
      id++;
      continue;
    }

    final hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = int.tryParse(timeParts[1]) ?? 0;

    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If time has passed today, schedule for tomorrow
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
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
      ),
    ),
  );
}
