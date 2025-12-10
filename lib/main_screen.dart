import 'package:flutter/material.dart';
import 'constants.dart';
import 'home_screen.dart';
import 'my_reservation_screen.dart';
// Kita pakai placeholder untuk Menu karena belum ada filenya
import 'menu_screen.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Default index 2 (Home) agar saat login langsung masuk ke tengah
  int _selectedIndex = 2; 

  final List<Widget> _pages = [
    const MenuScreen(),                          // Index 0: Menu
    const MyReservationScreen(initialIndex: 0),  // Index 1: Reservasi (Tab Berlangsung)
    const HomeScreen(),                          // Index 2: Home Screen
    const MyReservationScreen(initialIndex: 1),  // Index 3: Riwayat (Tab History)
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
      
      // Body berubah sesuai tombol bawah
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
          type: BottomNavigationBarType.fixed, // Fixed agar 4 icon muat rapi
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: AppStyles.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
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
              icon: Icon(Icons.history), // Icon Riwayat di sini
              label: 'Riwayat',
            ),
          ],
        ),
      ),
    );
  }
}