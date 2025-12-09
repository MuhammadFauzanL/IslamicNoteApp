import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'pages/profile/profile_page.dart';
import 'pages/user_home.dart';
import 'pages/home/home.dart';
import 'pages/doa/doa_list.dart';
import 'pages/artikel/artikel_list.dart';
import 'pages/chatbot/chatbot.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await initNotifications();

  runApp(const IslamicNoteApp());
}

class IslamicNoteApp extends StatefulWidget {
  const IslamicNoteApp({Key? key}) : super(key: key);

  @override
  State<IslamicNoteApp> createState() => _IslamicNoteAppState();
}

class _IslamicNoteAppState extends State<IslamicNoteApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // Buat primary swatch warna dari #00ADB5
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF00ADB5);

    return MaterialApp(
      title: 'Islamic Note App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: createMaterialColor(accentColor),
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
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: createMaterialColor(accentColor),
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
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: UserHomePage(
        toggleTheme: toggleTheme,
        isDarkMode: _isDarkMode,
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/doa_list': (context) => DoaListPage(),
        '/artikel_list': (context) => ArtikelListPage(),
        '/chatbot': (context) => const ChatbotPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
