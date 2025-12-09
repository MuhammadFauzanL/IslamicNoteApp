import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:islamicnoteapp/pages/artikel/artikel_list.dart';
import 'package:islamicnoteapp/pages/chatbot/chatbot.dart';
import 'package:islamicnoteapp/pages/doa/doa_list.dart';
import 'dart:convert';
import '../../core/notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  Map<String, String> jadwalSholat = {};
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
          jadwalSholat = {
            'Subuh': timings['Fajr'],
            'Dzuhur': timings['Dhuhr'],
            'Ashar': timings['Asr'],
            'Maghrib': timings['Maghrib'],
            'Isya': timings['Isha'],
          };
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

  void navigateWithFade(BuildContext context, Widget page) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ));
  }

  String getNextPrayer() {
    final now = TimeOfDay.now();
    // Ubah string jam "HH:mm" ke TimeOfDay
    TimeOfDay toTimeOfDay(String time) {
      final parts = time.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    for (var prayer in ['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya']) {
      if (!jadwalSholat.containsKey(prayer)) continue;
      final prayerTime = toTimeOfDay(jadwalSholat[prayer]!);
      if ((prayerTime.hour > now.hour) ||
          (prayerTime.hour == now.hour && prayerTime.minute > now.minute)) {
        return prayer;
      }
    }
    // Jika sudah lewat semua, kembali ke Subuh besok
    return 'Subuh';
  }

  Widget buildPrayerTimeCard(String prayerName, String time, bool isNext, Color accentColor) {
    final textColor = isNext ? Colors.white : Colors.grey[300];
    final bgColor = isNext ? accentColor : Colors.transparent;

    return Card(
      color: bgColor,
      elevation: isNext ? 5 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(Icons.access_time, color: isNext ? Colors.white : accentColor),
        title: Text(
          prayerName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 18,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 18,
            color: textColor,
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF222831);
    final Color textColor = const Color(0xFFEEEEEE);
    final Color accentColor = const Color(0xFF00ADB5);

    final nextPrayer = getNextPrayer();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF393E46),
        title: const Text('Home - Jadwal Sholat'),
      ),
      body: RefreshIndicator(
        color: accentColor,
        onRefresh: fetchJadwalSholat,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: accentColor),
                )
              : errorMessage.isNotEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Center(
                          child: Text(
                            errorMessage,
                            style: TextStyle(color: textColor, fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Text(
                          'Jadwal Sholat Hari Ini:',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...jadwalSholat.entries.map((entry) => buildPrayerTimeCard(
                              entry.key,
                              entry.value,
                              entry.key == nextPrayer,
                              accentColor,
                            )),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            navigateWithFade(context, DoaListPage());
                          },
                          child: const Text('Daftar Doa'),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            navigateWithFade(context, ArtikelListPage());
                          },
                          child: const Text('Daftar Artikel'),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            navigateWithFade(context, const ChatbotPage());
                          },
                          child: const Text('Chatbot'),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            await scheduleAllPrayerNotifications();
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Notifikasi pengingat sholat sudah dijadwalkan!',
                                ),
                              ),
                            );
                          },
                          child: const Text('Jadwalkan Notifikasi Pengingat Sholat'),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
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
