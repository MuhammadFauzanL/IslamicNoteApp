import 'package:flutter/material.dart';
import '../../core/notifications.dart'; // import file notifications.dart

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  String jadwalSholat = '';

  @override
  void initState() {
    super.initState();
    fetchJadwalSholat();
  }

  Future<void> fetchJadwalSholat() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      jadwalSholat =
          'Subuh: 04:30, Dzuhur: 12:00, Ashar: 15:00, Maghrib: 18:00, Isya: 19:30';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home - Jadwal Sholat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jadwal Sholat Hari Ini:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(jadwalSholat, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/doa_list');
                    },
                    child: const Text('Daftar Doa'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/artikel_list');
                    },
                    child: const Text('Daftar Artikel'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chatbot');
                    },
                    child: const Text('Chatbot'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await scheduleAllPrayerNotifications();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Notifikasi pengingat sholat sudah dijadwalkan!')),
                      );
                    },
                    child: const Text('Jadwalkan Notifikasi Pengingat Sholat'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      showPrayerReminderNotification('Subuh');
                    },
                    child:
                        const Text('Tes Notifikasi Pengingat Sholat (5 detik)'),
                  ),
                ],
              ),
      ),
    );
  }
}
