import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'constants.dart';
// Import halaman-halaman yang akan ditampilkan
import 'home_screen.dart'; 
import 'my_reservation_screen.dart';
import 'menu_screen.dart'; 
// 1. IMPORT FILE FEEDBACK SCREEN (Pastikan file ini sudah dibuat)
import 'feedback_screen.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Mulai di index 2 agar langsung terbuka di Home
  int _selectedIndex = 2; 

  // Daftar Halaman
  final List<Widget> _pages = [
    const MenuScreen(),                         // 0: Menu
    const MyReservationScreen(initialIndex: 0), // 1: Reservasi
    const HomeScreen(),                         // 2: HOME
    const MyReservationScreen(initialIndex: 1), // 3: Riwayat
    const FeedbackScreen(),                     // 4: FEEDBACK (Baru)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // Body ini akan berubah sesuai icon yang diklik
      body: _pages[_selectedIndex],

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed, // Fixed agar icon tetap rapi meski ada 5
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold), // Sedikit diperkecil fontnya agar muat 5 menu
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Reservasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30), 
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history), 
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.reviews), // Atau bisa pakai Icons.feedback
              label: 'Feedback',
            ),
          ],
        ),
      ),
    );
  }
}