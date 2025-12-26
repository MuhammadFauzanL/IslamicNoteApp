import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import '../../core/notifications.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(int)? onTabChange;

  const HomePage({super.key, this.isDarkMode = true, this.onTabChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  Map<String, String> jadwalSholat = {};
  String errorMessage = '';
  String locationName = 'Mendeteksi lokasi...';

  @override
  void initState() {
    super.initState();
    _initLocationAndFetch();
  }

  Future<void> _initLocationAndFetch() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      locationName = 'Mendeteksi lokasi...';
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _fetchWithFallback();
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await _fetchWithFallback();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await _fetchWithFallback();
        return;
      }

      Position? position;

      // Try getLastKnownPosition first (faster)
      position = await Geolocator.getLastKnownPosition();

      if (position == null) {
        // If no last known, try getCurrentPosition
        try {
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
          ).timeout(const Duration(seconds: 20));
        } catch (e) {
          // Position fetch failed
        }
      }

      if (position == null) {
        await _fetchWithFallback();
        return;
      }

      // Get city name from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            locationName = place.subAdministrativeArea ??
                place.locality ??
                place.administrativeArea ??
                'Lokasi Anda';
          });
        }
      } catch (e) {
        setState(() {
          locationName = 'Lat: ${position!.latitude.toStringAsFixed(2)}';
        });
      }

      // Fetch prayer times using coordinates (Method 11 = Kementerian Agama RI)
      await _fetchPrayerTimes(position.latitude, position.longitude);
    } catch (e) {
      // Fallback to Jakarta on any error
      await _fetchWithFallback();
    }
  }

  Future<void> _fetchWithFallback() async {
    setState(() {
      locationName = 'Jakarta (default)';
    });
    // Jakarta coordinates
    await _fetchPrayerTimes(-6.2088, 106.8456);
  }

  Future<void> _fetchPrayerTimes(double lat, double lng) async {
    try {
      // Method 11 = Kementerian Agama RI (more accurate for Indonesia)
      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lng&method=11'));

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
          errorMessage =
              'Gagal memuat jadwal sholat. Kode: ${response.statusCode}';
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

  Widget buildPrayerTimeCard(String prayerName, String time, bool isNext,
      Color accentColor, bool isDark) {
    // Colors for next prayer (highlighted)
    final nextTextColor = Colors.white;
    // Colors for other prayers
    final normalTextColor = isDark ? Colors.grey[300] : Colors.grey[800];
    final iconColor = isNext ? Colors.white : accentColor;
    final bgColor = isNext ? accentColor : Colors.transparent;

    return Card(
      color: bgColor,
      elevation: isNext ? 5 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(Icons.access_time, color: iconColor),
        title: Text(
          prayerName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isNext ? nextTextColor : normalTextColor,
            fontSize: 18,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 18,
            color: isNext ? nextTextColor : normalTextColor,
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;
    final Color bgColor =
        isDark ? const Color(0xFF222831) : const Color(0xFFEEEEEE);
    final Color textColor =
        isDark ? const Color(0xFFEEEEEE) : const Color(0xFF222831);
    final Color accentColor = const Color(0xFF00ADB5);

    final nextPrayer = getNextPrayer();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: accentColor,
          onRefresh: _initLocationAndFetch,
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
                            'Jadwal Sholat Hari Ini',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 16,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                locationName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ...jadwalSholat.entries
                              .map((entry) => buildPrayerTimeCard(
                                    entry.key,
                                    entry.value,
                                    entry.key == nextPrayer,
                                    accentColor,
                                    isDark,
                                  )),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.menu_book),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              if (widget.onTabChange != null) {
                                widget.onTabChange!(1); // Index 1 = Doa
                              }
                            },
                            label: const Text('Daftar Doa'),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.article),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              if (widget.onTabChange != null) {
                                widget.onTabChange!(2); // Index 2 = Artikel
                              }
                            },
                            label: const Text('Daftar Artikel'),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.smart_toy),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              if (widget.onTabChange != null) {
                                widget.onTabChange!(3); // Index 3 = Chatbot
                              }
                            },
                            label: const Text('Chatbot'),
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
                            child: const Text(
                                'Jadwalkan Notifikasi Pengingat Sholat'),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
