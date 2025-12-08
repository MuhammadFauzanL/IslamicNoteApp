import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoaDetailPage extends StatefulWidget {
  const DoaDetailPage({Key? key}) : super(key: key);

  @override
  _DoaDetailPageState createState() => _DoaDetailPageState();
}

class _DoaDetailPageState extends State<DoaDetailPage> {
  bool _isBookmarked = false;
  late String doaTitle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    doaTitle = ModalRoute.of(context)!.settings.arguments as String? ?? 'Detail Doa';
    _loadBookmark();
  }

  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBookmarked = prefs.getBool(doaTitle) ?? false;
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    prefs.setBool(doaTitle, _isBookmarked);
  }

  @override
  Widget build(BuildContext context) {
    // Dummy detail, nanti diganti dengan data API sesuai doaTitle
    final String arab = 'اللَّهُمَّ صَيِّبًا نَافِعًا';
    final String latin = "Allâhummâ shayyiban nâfi'an";
    final String arti = "Ya Allah, turunkanlah pada kami hujan yang bermanfaat.";

    return Scaffold(
      appBar: AppBar(
        title: Text(doaTitle),
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
            tooltip: _isBookmarked ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Arab:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(arab, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            const Text('Latin:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(latin, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Arti:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(arti, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
