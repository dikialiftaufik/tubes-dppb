import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'reservation_form_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'models.dart';
import 'menu_detail_screen.dart';
import 'menu_catalog_screen.dart';
import 'notification_screen.dart';
import 'services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: Text('The Komars', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.message, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuCatalogScreen()))),
          IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()))),
          IconButton(icon: const Icon(Icons.shopping_cart, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()))),
          IconButton(icon: const Icon(Icons.person, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mau makan enak\nhari ini?', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondary)),
            const SizedBox(height: 20),
            
            // BANNER RESERVASI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reservasi Tempat', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Booking meja tanpa antri!', style: GoogleFonts.poppins(color: Colors.white70)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReservationFormScreen())),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                    child: const Text('Booking Sekarang'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // JUDUL MENU
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Menu Favorit', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuCatalogScreen())),
                  child: Text('Lihat Semua', style: GoogleFonts.poppins(color: AppColors.primary)),
                )
              ],
            ),
            const SizedBox(height: 12),

            // GRID MENU (DARI API)
            FutureBuilder<List<dynamic>>(
              future: ApiService().getMenu(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Text("Menu belum tersedia");

                final menus = snapshot.data!.take(4).toList(); // Ambil max 4 menu

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    final item = menus[index];
                    // Construct URL Gambar yang Benar
                    String rawFoto = item['foto'] ?? '';
                    String imageUrl = rawFoto.startsWith('http') 
                        ? rawFoto 
                        : "${AppConstants.baseUrl.replaceAll('/api', '')}/storage/$rawFoto";

                    // Buat Objek MenuItem
                    final menuItem = MenuItem(
                      id: item['id'].toString(),
                      name: item['nama_menu'] ?? 'Menu',
                      category: item['kategori'] ?? 'Umum',
                      meat: item['daging'] ?? item['meat'] ?? '',
                      price: double.tryParse(item['harga'].toString()) ?? 0,
                      description: item['deskripsi'] ?? '',
                      imageUrl: imageUrl, 
                    );

                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MenuDetailScreen(menuItem: menuItem))),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: Colors.grey[200], child: const Icon(Icons.fastfood))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(menuItem.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text(currencyFormatter.format(menuItem.price), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}