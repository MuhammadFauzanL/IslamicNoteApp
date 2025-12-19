import 'package:flutter/material.dart';
import '../data/doa_dummy.dart';
import '../models/doa.dart';

class DoaDetailPage extends StatelessWidget {
  const DoaDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String doaId = ModalRoute.of(context)!.settings.arguments as String;

    final Doa doa = doaList.firstWhere((d) => d.id == doaId);

    return Scaffold(
      appBar: AppBar(title: Text(doa.judul)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('Arab', doa.arab, 22),
            _section('Latin', doa.latin, 18),
            _section('Arti', doa.arti, 16),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String content, double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 6),
        Text(content, style: TextStyle(fontSize: size)),
        const SizedBox(height: 20),
      ],
    );
  }
}
