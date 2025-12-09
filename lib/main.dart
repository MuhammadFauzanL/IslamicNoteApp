import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'pages/profile/profile_page.dart';
import 'pages/user_home.dart';
import 'pages/home/home.dart';
import 'pages/doa/doa_list.dart';
import 'pages/doa/doa_detail.dart';
import 'pages/artikel/artikel_list.dart';
import 'pages/artikel/artikel_detail.dart';
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

  // Inisialisasi timezone wajib sebelum schedule notif
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamic Note App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: UserHomePage(
        toggleTheme: toggleTheme,
        isDarkMode: _isDarkMode,
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/doa_list': (context) => DoaListPage(),
        '/doa_detail': (context) => DoaDetailPage(), 
        '/artikel_list': (context) => ArtikelListPage(),
        '/artikel_detail': (context) => const ArtikelDetailPage(),
        '/chatbot': (context) => const ChatbotPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
