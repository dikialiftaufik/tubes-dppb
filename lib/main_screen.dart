import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'constants.dart';
import 'home_screen.dart'; 
import 'my_reservation_screen.dart';
import 'menu_screen.dart'; 
import 'feedback_screen.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; 

  final List<Widget> _pages = [
    const MenuScreen(),                         
    const MyReservationScreen(initialIndex: 0), 
    const HomeScreen(),                         
    const MyReservationScreen(initialIndex: 1), 
    const FeedbackScreen(),                     
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
      
      body: _pages[_selectedIndex],

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
          type: BottomNavigationBarType.fixed, 
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold), 
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
              icon: Icon(Icons.reviews), 
              label: 'Feedback',
            ),
          ],
        ),
      ),
    );
  }
}