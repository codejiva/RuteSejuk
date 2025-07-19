import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan ListView untuk menampilkan daftar
      body: ListView.builder(
        itemCount: 5, // Anggap ada 5 item riwayat
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.route_outlined, color: Colors.deepPurple),
            title: Text('Rute Pagi #${index + 1}'),
            subtitle: const Text('Kemang - Blok M'),
            trailing: const Text('5.2 km'),
            onTap: () {
              // Nanti bisa diarahkan ke detail rute
            },
          );
        },
      ),
    );
  }
}
