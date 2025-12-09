import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/notifications.dart'; // import file notifications.dart

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  String jadwalSholat = '';
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchJadwalSholat();
  }

  Future<void> fetchJadwalSholat() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/timingsByCity?city=Jakarta&country=Indonesia&method=2'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        setState(() {
          jadwalSholat = '''
Subuh: ${timings['Fajr']}
Dzuhur: ${timings['Dhuhr']}
Ashar: ${timings['Asr']}
Maghrib: ${timings['Maghrib']}
Isya: ${timings['Isha']}
''';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal memuat jadwal sholat. Kode: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home - Jadwal Sholat')),
      body: RefreshIndicator(
        onRefresh: fetchJadwalSholat,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Center(child: Text(errorMessage)),
                      ],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const Text(
                          'Jadwal Sholat Hari Ini:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                          child: const Text('Tes Notifikasi Pengingat Sholat (5 detik)'),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
