import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'auth/pages/auth_choice_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await initNotifications();

  runApp(const IslamicNoteApp());
}

class IslamicNoteApp extends StatefulWidget {
  const IslamicNoteApp({super.key});

  @override
  State<IslamicNoteApp> createState() => _IslamicNoteAppState();
}

class _IslamicNoteAppState extends State<IslamicNoteApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF00ADB5);

    return MaterialApp(
      title: 'Islamic Note App',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _buildLightTheme(accentColor),
      darkTheme: _buildDarkTheme(accentColor),

      // ===== Entry Point =====
      home: const AuthChoicePage(),
    );
  }

  // ===== Light Theme =====
  ThemeData _buildLightTheme(Color accentColor) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: accentColor,
      scaffoldBackgroundColor: const Color(0xFFEEEEEE),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF00ADB5),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ===== Dark Theme =====
  ThemeData _buildDarkTheme(Color accentColor) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: accentColor,
      scaffoldBackgroundColor: const Color(0xFF222831),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF393E46),
        foregroundColor: Color(0xFFEEEEEE),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
