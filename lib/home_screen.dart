import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'reservation_form_screen.dart'; 
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'models.dart';
import 'menu_detail_screen.dart';
import 'menu_catalog_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // REVISI 1: Matikan tombol back otomatis
        automaticallyImplyLeading: false, 
        backgroundColor: AppColors.primary,
        title: Text(
          'The Komars',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Ikon Pesan (Menu Lengkap)
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white),
            tooltip: 'Menu Lengkap',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuCatalogScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
          // Ikon Keranjang
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            tooltip: 'Keranjang',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
          // Ikon Profil
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: 'Profil Saya',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 8), 
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sapaan
            Text(
              'Mau makan enak\nhari ini?',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),

            // Banner Promo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reservasi Tempat',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Booking meja tanpa antri sekarang juga!',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReservationFormScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Booking Sekarang'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text(
              'Menu Favorit',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            
            // Grid Menu Favorit - 4 Menu Terbaik
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                // Menu favorit: Sate Ayam, Sate Sapi, Tongseng Ayam, Tongseng Sapi
                final favoriteMenus = [
                  MenuItem(
                    id: '1',
                    name: 'Sate Ayam',
                    category: 'Sate',
                    meat: 'Ayam',
                    price: 35000,
                    description: 'Sate ayam empuk dengan bumbu kacang yang lezat',
                    imageUrl: 'assets/sate_ayam.png',
                  ),
                  MenuItem(
                    id: '2',
                    name: 'Sate Sapi',
                    category: 'Sate',
                    meat: 'Sapi',
                    price: 45000,
                    description: 'Sate daging sapi premium dengan bumbu tradisional',
                    imageUrl: 'assets/sate_sapi.png',
                  ),
                  MenuItem(
                    id: '4',
                    name: 'Tongseng Ayam',
                    category: 'Tongseng',
                    meat: 'Ayam',
                    price: 32000,
                    description: 'Tongseng ayam berkuah dengan sayuran segar',
                    imageUrl: 'assets/tongseng_ayam.png',
                  ),
                  MenuItem(
                    id: '5',
                    name: 'Tongseng Sapi',
                    category: 'Tongseng',
                    meat: 'Sapi',
                    price: 42000,
                    description: 'Tongseng daging sapi empuk dengan kuah gurih',
                    imageUrl: 'assets/tongseng_sapi.png',
                  ),
                ];
                
                final menu = favoriteMenus[index];
                
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuDetailScreen(menuItem: menu),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Image placeholder
                        Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menu.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                menu.meat,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${menu.price.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}