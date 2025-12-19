import 'package:flutter/material.dart';
import 'home_controller.dart';
import '../doa/pages/doa_list_page.dart';
import '../artikel/pages/artikel_list_page.dart';
import '../chatbot/chatbot_page.dart';
import '../../core/notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  bool _isLoading = true;
  String _errorMessage = '';

  final Color _bgColor = const Color(0xFF222831);
  final Color _textColor = const Color(0xFFEEEEEE);
  final Color _accentColor = const Color(0xFF00ADB5);

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await _controller.loadPrayerTimes();
    } catch (e) {
      _errorMessage = e.toString();
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _navigateWithFade(Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildPrayerCard(String prayerName, String time, bool isNext) {
    final textColor = isNext ? Colors.white : Colors.grey[300];
    final bgColor = isNext ? _accentColor : Colors.transparent;

    return Card(
      color: bgColor,
      elevation: isNext ? 5 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          Icons.access_time,
          color: isNext ? Colors.white : _accentColor,
        ),
        title: Text(
          prayerName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
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
    final nextPrayer = _controller.getNextPrayer();

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF393E46),
        title: const Text('Home - Jadwal Sholat'),
      ),
      body: RefreshIndicator(
        color: _accentColor,
        onRefresh: _loadPrayerTimes,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: _accentColor))
              : _errorMessage.isNotEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: _textColor, fontSize: 16),
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
                        color: _accentColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Prayer Times
                    ..._controller.prayerTimes.entries.map(
                      (entry) => _buildPrayerCard(
                        entry.key,
                        entry.value,
                        entry.key == nextPrayer,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Navigation Buttons
                    ElevatedButton(
                      onPressed: () {
                        _navigateWithFade(DoaListPage());
                      },
                      child: const Text('Daftar Doa'),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        _navigateWithFade(ArtikelListPage());
                      },
                      child: const Text('Daftar Artikel'),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        _navigateWithFade(const ChatbotPage());
                      },
                      child: const Text('Chatbot'),
                    ),

                    const SizedBox(height: 30),

                    /// Notification Actions
                    ElevatedButton(
                      onPressed: () async {
                        await scheduleAllPrayerNotifications();
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Notifikasi pengingat sholat dijadwalkan',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Jadwalkan Notifikasi Pengingat Sholat',
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        showPrayerReminderNotification('Subuh');
                      },
                      child: const Text(
                        'Tes Notifikasi Pengingat Sholat (5 detik)',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
