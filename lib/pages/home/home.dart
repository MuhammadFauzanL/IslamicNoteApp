import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:islamicnoteapp/pages/chatbot/chatbot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/notifications.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(int)? onTabChange;

  const HomePage({
    super.key,
    required this.isDarkMode,
    this.onTabChange,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  bool isOffline = false;

  Map<String, String> jadwalSholat = {};
  String locationName = 'Mendeteksi lokasi...';

  @override
  void initState() {
    super.initState();
    _init();
  }

  // =========================
  // INIT (OFFLINE FIRST)
  // =========================
  Future<void> _init() async {
    await _loadCache(); // tampilkan cache / default dulu
    await _fetchInBackground(); // update online (wait for location permission first)

    // Request notification permission after location (for first install)
    if (mounted) {
      // Add small delay to prevent permission dialog conflict
      await Future.delayed(const Duration(milliseconds: 500));
      await requestNotificationPermission();
    }
  }

  // =========================
  // LOAD CACHE + DEFAULT
  // =========================
  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cached_prayer_times');
    final cachedLoc = prefs.getString('cached_location');

    if (cached != null) {
      setState(() {
        jadwalSholat = Map<String, String>.from(json.decode(cached));
        locationName = cachedLoc ?? locationName;
        isLoading = false;
        isOffline = true;
      });
    } else {
      // ✅ DEFAULT STATIS (AMAN OFFLINE TOTAL)
      setState(() {
        jadwalSholat = {
          'Subuh': '--:--',
          'Dzuhur': '--:--',
          'Ashar': '--:--',
          'Maghrib': '--:--',
          'Isya': '--:--',
        };
        locationName = 'Lokasi belum tersedia';
        isLoading = false;
        isOffline = true;
      });
    }
  }

  // =========================
  // BACKGROUND UPDATE
  // =========================
  Future<void> _fetchInBackground() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _fetchWithFallback();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await _fetchWithFallback();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          locationName = place.subAdministrativeArea ??
              place.locality ??
              place.administrativeArea ??
              locationName;
        }
      } catch (_) {}

      await _fetchPrayerTimes(
        position.latitude,
        position.longitude,
      );
    } catch (_) {
      setState(() => isOffline = true);
    }
  }

  // =========================
  // FALLBACK JAKARTA
  // =========================
  Future<void> _fetchWithFallback() async {
    locationName = 'Jakarta (default)';
    await _fetchPrayerTimes(-6.2088, 106.8456);
  }

  // =========================
  // FETCH API
  // =========================
  Future<void> _fetchPrayerTimes(double lat, double lng) async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.aladhan.com/v1/timings'
          '?latitude=$lat&longitude=$lng&method=11',
        ),
      );

      if (res.statusCode == 200) {
        final timings = json.decode(res.body)['data']['timings'];

        final data = <String, String>{
          'Subuh': timings['Fajr'].toString(),
          'Dzuhur': timings['Dhuhr'].toString(),
          'Ashar': timings['Asr'].toString(),
          'Maghrib': timings['Maghrib'].toString(),
          'Isya': timings['Isha'].toString(),
        };

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'cached_prayer_times',
          json.encode(data),
        );
        await prefs.setString(
          'cached_location',
          locationName,
        );

        setState(() {
          jadwalSholat = data;
          isOffline = false;
        });
      }
    } catch (_) {
      setState(() => isOffline = true);
    }
  }

  // =========================
  // NEXT PRAYER
  // =========================
  String getNextPrayer() {
    final now = TimeOfDay.now();

    TimeOfDay toTime(String time) {
      if (time == '--:--') {
        return const TimeOfDay(hour: 99, minute: 99);
      }
      final p = time.split(':');
      return TimeOfDay(
        hour: int.parse(p[0]),
        minute: int.parse(p[1]),
      );
    }

    for (final prayer in ['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya']) {
      if (!jadwalSholat.containsKey(prayer)) continue;
      final t = toTime(jadwalSholat[prayer]!);
      if (t.hour > now.hour || (t.hour == now.hour && t.minute > now.minute)) {
        return prayer;
      }
    }
    return 'Subuh';
  }

  // =========================
  // PRAYER CARD
  // =========================
  Widget buildPrayerTimeCard(
    String prayerName,
    String time,
    bool isNext,
    Color accentColor,
    bool isDark,
  ) {
    final nextTextColor = Colors.white;
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

  // =========================
  // UI
  // =========================
  // Helper to handle permission request with dialog fallback
  Future<bool> _checkOrRequestPermission(BuildContext context) async {
    // 1. Try native request (popup)
    final granted = await requestNotificationPermission();
    if (granted) return true;

    // 2. If denied (likely permanently or system block), ask to open settings
    if (!mounted) return false;

    bool? openSettings = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Izin Notifikasi Diperlukan'),
        content: const Text(
          'Sistem memblokir permintaan izin otomatis. Mohon aktifkan notifikasi secara manual di pengaturan agar pengingat sholat berfungsi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );

    if (openSettings == true) {
      await openNotificationSettings();
      // We can't easily wait for return result here perfectly,
      // but user can try clicking the button again after returning.
      return false;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;
    final Color bgColor =
        isDark ? const Color(0xFF222831) : const Color(0xFFEEEEEE);
    final Color accentColor = const Color(0xFF00ADB5);

    final nextPrayer = getNextPrayer();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: accentColor,
          onRefresh: _init,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: accentColor,
                    ),
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
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            locationName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...jadwalSholat.entries.map(
                        (e) => buildPrayerTimeCard(
                          e.key,
                          e.value,
                          e.key == nextPrayer,
                          accentColor,
                          isDark,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.menu_book, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => widget.onTabChange?.call(1),
                        label: const Text(
                          'Daftar Doa',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.article, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => widget.onTabChange?.call(2),
                        label: const Text(
                          'Daftar Artikel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.smart_toy, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // Langsung navigasi ke ChatbotPage
                          // Login popup akan ditampilkan oleh ChatbotPage jika belum login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChatbotPage(),
                            ),
                          );
                        },
                        label: const Text(
                          'Chatbot',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          // Check if prayer times are available
                          if (jadwalSholat.isEmpty ||
                              jadwalSholat['Subuh'] == '--:--') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Jadwal sholat belum tersedia. Mohon tunggu atau refresh halaman.',
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          // Request permission (with dialog fallback)
                          final permissionGranted =
                              await _checkOrRequestPermission(context);
                          if (!permissionGranted) return;

                          // Show immediate feedback
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menjadwalkan notifikasi...'),
                              duration: Duration(seconds: 1),
                            ),
                          );

                          try {
                            await scheduleAllPrayerNotifications(jadwalSholat);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '✅ Notifikasi dijadwalkan!\nSubuh ${jadwalSholat['Subuh']}, Dzuhur ${jadwalSholat['Dzuhur']}, Ashar ${jadwalSholat['Ashar']}, Maghrib ${jadwalSholat['Maghrib']}, Isya ${jadwalSholat['Isya']}',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ Gagal menjadwalkan: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Jadwalkan Notifikasi Pengingat Sholat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
