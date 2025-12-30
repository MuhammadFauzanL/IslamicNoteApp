import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'pages/chatbot/chatbot_guard.dart';
import 'pages/user_home.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/doa/doa_list.dart';
import 'pages/artikel/artikel_list.dart';
import 'pages/chatbot/chatbot.dart';
import 'pages/profile/profile_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

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

  MaterialColor createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final ds = 0.5 - strength;
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
    const accentColor = Color(0xFF00ADB5);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
  brightness: Brightness.light,
  primarySwatch: createMaterialColor(accentColor),
  scaffoldBackgroundColor: const Color(0xFFEEEEEE),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00ADB5), // 🔵 BIRU
    foregroundColor: Colors.white,      // teks & icon putih
    elevation: 1,
  ),
),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: createMaterialColor(const Color(0xFF00ADB5)),
        scaffoldBackgroundColor: const Color(0xFF222831),
      ),


      home: UserHomePage(
        toggleTheme: toggleTheme,
        isDarkMode: _isDarkMode,
      ),

      routes: {
        '/home': (context) => UserHomePage(
              toggleTheme: toggleTheme,
              isDarkMode: _isDarkMode,
            ),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/doa_list': (_) => DoaListPage(),
        '/artikel_list': (_) => ArtikelListPage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
