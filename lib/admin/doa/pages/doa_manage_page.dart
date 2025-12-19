import 'package:flutter/material.dart';
import '../services/doa_admin_service.dart';
import '../models/doa_model.dart';
import 'doa_form_page.dart';

class DoaManagePage extends StatefulWidget {
  const DoaManagePage({super.key});

  @override
  State<DoaManagePage> createState() => _DoaManagePageState();
}

class _DoaManagePageState extends State<DoaManagePage> {
  late Future<List<Doa>> _futureDoa;

  @override
  void initState() {
    super.initState();
    _futureDoa = DoaAdminService.getAllDoa();
  }

  void _refresh() {
    setState(() {
      _futureDoa = DoaAdminService.getAllDoa();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Doa')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DoaFormPage()),
          );
          _refresh();
        },
      ),
      body: FutureBuilder<List<Doa>>(
        future: _futureDoa,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doa = data[index];
              return ListTile(
                title: Text(doa.judul),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoaFormPage(doa: doa),
                          ),
                        );
                        _refresh();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DoaAdminService.deleteDoa(doa.id);
                        _refresh();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
