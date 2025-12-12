import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'models.dart';
import 'menu_detail_screen.dart';

class MenuCatalogScreen extends StatelessWidget {
  const MenuCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Semua menu items
    final List<MenuItem> allMenuItems = [
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
        id: '3',
        name: 'Sate Kambing',
        category: 'Sate',
        meat: 'Kambing',
        price: 50000,
        description: 'Sate kambing empuk dengan aroma harum',
        imageUrl: 'assets/sate_kambing.png',
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
      MenuItem(
        id: '6',
        name: 'Tongseng Kambing',
        category: 'Tongseng',
        meat: 'Kambing',
        price: 48000,
        description: 'Tongseng kambing dengan rempah-rempah pilihan',
        imageUrl: 'assets/tongseng_kambing.png',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Katalog Menu Lengkap',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allMenuItems.length,
        itemBuilder: (context, index) {
          final item = allMenuItems[index];
          return _buildMenuCard(context, item, index);
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuItem item, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuDetailScreen(menuItem: item),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: index != 5 ? 16 : 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image placeholder - full height
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
            ),
            // Info section - full width remaining
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name & Category
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Category badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.category,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Meat type
                            Text(
                              item.meat,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Price & Arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${item.price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
