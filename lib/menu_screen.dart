import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'models.dart';
import 'menu_detail_screen.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Dummy menu data
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

  String _selectedCategory = 'Semua';

  List<MenuItem> get filteredItems {
    if (_selectedCategory == 'Semua') return allMenuItems;
    return allMenuItems.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final crossAxisCount = isMobile ? 2 : 3;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Daftar Menu',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Semua'),
                    const SizedBox(width: 8),
                    _buildCategoryChip('Sate'),
                    const SizedBox(width: 8),
                    _buildCategoryChip('Tongseng'),
                  ],
                ),
              ),
            ),
            
            // Menu Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return _buildMenuCard(context, item);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(
        category,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.secondary,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = category;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary,
      side: BorderSide(
        color: isSelected ? AppColors.primary : Colors.grey[300]!,
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuDetailScreen(menuItem: item),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 100,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.meat,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Rp ${item.price.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: AppColors.primary,
                      ),
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
