import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Untuk format mata uang
import 'constants.dart';
import 'reservation_form_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'models.dart'; // Pastikan MenuItem ada di sini atau hapus jika tidak pakai model
import 'menu_detail_screen.dart';
import 'menu_catalog_screen.dart';
import 'notification_screen.dart';
import 'services/api_service.dart'; // Import API Service

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Setup format mata uang Rupiah
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: Text(
          'The Komars',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuCatalogScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mau makan enak\nhari ini?',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 20),

            // Banner Reservasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                ],
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Booking Sekarang'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu Favorit',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuCatalogScreen()));
                  }, 
                  child: Text('Lihat Semua', style: GoogleFonts.poppins(color: AppColors.primary))
                )
              ],
            ),

            const SizedBox(height: 12),

            // Grid Menu Dinamis dari API
            FutureBuilder<List<dynamic>>(
              future: ApiService().getMenu(), // Mengambil data dari PABW
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text("Gagal memuat menu.", style: GoogleFonts.poppins()));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Tidak ada menu tersedia.", style: GoogleFonts.poppins()));
                }

                final menus = snapshot.data!;
                
                // Batasi tampilan di Home hanya 4 menu saja agar tidak kepanjangan
                final displayMenus = menus.length > 4 ? menus.sublist(0, 4) : menus;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75, // Disesuaikan agar muat gambar + teks
                  ),
                  itemCount: displayMenus.length,
                  itemBuilder: (context, index) {
                    final item = displayMenus[index];
                    
                    // Konstruksi URL Gambar
                    // Asumsi: di database fieldnya 'foto' berisi filename (misal 'sate.jpg')
                    // Path PABW biasanya: http://ip:8000/storage/menu/filename.jpg
                    // Sesuaikan 'menu/' jika folder di storage kamu berbeda
                    String imageUrl = "${AppConstants.baseUrl.replaceAll('/api', '')}/storage/menu/${item['foto'] ?? ''}";
                    
                    // Fallback jika tidak ada gambar
                    if (item['foto'] == null || item['foto'] == '') {
                      // Gunakan placeholder atau assets lokal jika mau
                      imageUrl = "https://via.placeholder.com/150"; 
                    }

                    // Mapping ke Object MenuItem (untuk dikirim ke Detail Screen)
                    final menuItemObj = MenuItem(
                      id: item['id'].toString(),
                      name: item['nama_menu'] ?? 'Tanpa Nama',
                      category: item['kategori'] ?? 'Umum',
                      meat: item['kategori'] ?? '', // Sesuaikan jika ada field daging
                      price: double.tryParse(item['harga'].toString()) ?? 0,
                      description: item['deskripsi'] ?? '',
                      imageUrl: imageUrl, // Kirim URL lengkap
                      // Tambahkan field isAsset: false di model MenuItem kamu agar tahu ini load dari network
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuDetailScreen(menuItem: menuItemObj),
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
                          children: [
                            // Gambar Menu
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['nama_menu'] ?? 'Menu',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['kategori'] ?? '-',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currencyFormatter.format(double.tryParse(item['harga'].toString()) ?? 0),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}