import 'package:flutter/material.dart';
import 'doa_data.dart';

class DoaDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Doa doa = ModalRoute.of(context)!.settings.arguments as Doa;

    return Scaffold(
      appBar: AppBar(title: Text(doa.judul)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Arab:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 4),
              Text(doa.arab, style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Text('Latin:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 4),
              Text(doa.latin, style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Arti:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 4),
              Text(doa.arti, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
