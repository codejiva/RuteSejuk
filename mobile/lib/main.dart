import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
void main() {
  runApp(const RuteSejukApp());
}

class RuteSejukApp extends StatelessWidget {
  const RuteSejukApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah widget utama yang membungkus seluruh aplikasi
    return MaterialApp(
      title: 'RuteSejuk',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Kita hilangkan banner "Debug" yang ada di pojok kanan atas
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Variabel untuk menyimpan indeks tab yang sedang aktif
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai tab
  // Untuk sekarang, kita isi dengan placeholder sederhana
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // Panggil widget dari file home_screen.dart
    HistoryScreen(), // Panggil widget dari file history_screen.dart
    ProfileScreen(), // Panggil widget dari file profile_screen.dart
  ];

  // Fungsi yang akan dipanggil saat item navigasi di-tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold adalah kerangka dasar untuk setiap halaman
    return Scaffold(
      appBar: AppBar(title: const Text('RuteSejuk')),
      body: Center(
        // Tampilkan widget sesuai tab yang dipilih
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple, // Sesuaikan warnanya
        onTap: _onItemTapped,
      ),
    );
  }
}
