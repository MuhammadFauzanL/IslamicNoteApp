import 'package:flutter/material.dart';

class ArtikelDetailPage extends StatefulWidget {
  const ArtikelDetailPage({Key? key}) : super(key: key);

  @override
  _ArtikelDetailPageState createState() => _ArtikelDetailPageState();
}

class _ArtikelDetailPageState extends State<ArtikelDetailPage> {
  bool isLoading = true;
  bool isError = false;

  String? artikelTitle;
  String content = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    artikelTitle = ModalRoute.of(context)!.settings.arguments as String?;
    fetchArtikelDetail();
  }

  Future<void> fetchArtikelDetail() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      // Simulasi delay fetch dari API/backend
      await Future.delayed(Duration(seconds: 2));

      // Dummy content, nanti diganti dengan data dari API sesuai artikelTitle
      if (artikelTitle != null) {
        content = 'Ini adalah isi artikel "$artikelTitle". Nanti akan diganti dengan data dari backend.';
      } else {
        content = 'Artikel tidak ditemukan.';
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artikelTitle ?? 'Detail Artikel'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Gagal mengambil data.'),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: fetchArtikelDetail,
                        child: Text('Coba Lagi'),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(content, style: TextStyle(fontSize: 16)),
                ),
    );
  }
}
