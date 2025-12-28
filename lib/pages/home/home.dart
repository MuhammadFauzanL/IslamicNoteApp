import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import '../../core/notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(int)? onTabChange;

  const HomePage({
    super.key,
    this.isDarkMode = true,
    this.onTabChange,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();

  bool isLoading = true;
  Map<String, String> jadwalSholat = {};
  String errorMessage = '';
  String locationName = 'Mendeteksi lokasi...';

  @override
  void initState() {
    super.initState();
    _initLocationAndFetch();
    _checkLogin(); // 🔐 hanya cek token, tidak memblok UI
  }

  /// 🔐 Cek token TANPA error jika belum login
  Future<void> _checkLogin() async {
    await storage.read(key: 'token');
  }

  // ================== LOKASI & JADWAL SHOLAT ==================

  Future<void> _initLocationAndFetch() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      locationName = 'Mendeteksi lokasi...';
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _fetchWithFallback();
        return;
      }

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

      Position? position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 20));

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        locationName = place.subAdministrativeArea ??
            place.locality ??
            place.administrativeArea ??
            'Lokasi Anda';
      }

      await _fetchPrayerTimes(position.latitude, position.longitude);
    } catch (_) {
      await _fetchWithFallback();
    }
  }

  Future<void> _fetchWithFallback() async {
    locationName = 'Jakarta (default)';
    await _fetchPrayerTimes(-6.2088, 106.8456);
  }

  Future<void> _fetchPrayerTimes(double lat, double lng) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lng&method=11'));

      if (response.statusCode == 200) {
        final timings = json.decode(response.body)['data']['timings'];

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
        throw Exception();
      }
    } catch (_) {
      setState(() {
        errorMessage = 'Gagal memuat jadwal sholat';
        isLoading = false;
      });
    }
  }

  // ================== HELPER ==================

  String getNextPrayer() {
    if (jadwalSholat.isEmpty) return '';

    final now = TimeOfDay.now();

    TimeOfDay parse(String time) {
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    for (final entry in jadwalSholat.entries) {
      final t = parse(entry.value);
      if (t.hour > now.hour ||
          (t.hour == now.hour && t.minute > now.minute)) {
        return entry.key;
      }
    }
    return 'Subuh';
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF00ADB5);
    final nextPrayer = getNextPrayer();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _initLocationAndFetch,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: accentColor),
                  )
                : errorMessage.isNotEmpty
                    ? ListView(
                        children: [
                          Center(
                            child: Text(
                              errorMessage,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        children: [
                          Text(
                            'Jadwal Sholat Hari Ini',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 4),
                              Text(locationName),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ...jadwalSholat.entries.map(
                            (e) => Card(
                              color:
                                  e.key == nextPrayer ? accentColor : null,
                              child: ListTile(
                                title: Text(
                                  e.key,
                                  style: TextStyle(
                                    color: e.key == nextPrayer
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                                trailing: Text(
                                  e.value,
                                  style: TextStyle(
                                    color: e.key == nextPrayer
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.menu_book),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                            ),
                            onPressed: () =>
                                widget.onTabChange?.call(1),
                            label: const Text('Daftar Doa'),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.article),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                            ),
                            onPressed: () =>
                                widget.onTabChange?.call(2),
                            label: const Text('Daftar Artikel'),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.smart_toy),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                            ),
                            onPressed: () =>
                                widget.onTabChange?.call(3),
                            label: const Text('Chatbot'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                            ),
                            onPressed: () async {
                              await scheduleAllPrayerNotifications();
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Notifikasi sholat berhasil dijadwalkan'),
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
