import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'models.dart';
import 'checkout_screen.dart';

// ==== FUNCTION FORMAT RUPIAH ====
String formatRupiah(double number) {
  return number.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Dummy cart data
  final List<CartItem> cartItems = [
    CartItem(
      menuItem: MenuItem(
        id: '1',
        name: 'Sate Ayam',
        category: 'Sate',
        meat: 'Ayam',
        price: 35000,
        description: 'Sate ayam empuk dengan bumbu kacang yang lezat',
        imageUrl: 'lib/assets/sateayam.jpg',
      ),
      quantity: 2,
    ),
    CartItem(
      menuItem: MenuItem(
        id: '5',
        name: 'Tongseng Sapi',
        category: 'Tongseng',
        meat: 'Sapi',
        price: 42000,
        description: 'Tongseng daging sapi empuk dengan kuah gurih',
        imageUrl: 'lib/assets/tongsengsapi.jpg',
      ),
      quantity: 1,
    ),
  ];

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Keranjang',
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: List.generate(
                        cartItems.length,
                        (index) => _buildCartItem(index),
                      ),
                    ),
                  ),
                ),
                _buildCheckoutSection(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang Kosong',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih menu favorit Anda terlebih dahulu',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================
  // CARD ITEM CART (SUDAH DIPERBAIKI)
  // ===============================
  Widget _buildCartItem(int index) {
    final item = cartItems[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: const Color.fromARGB(255, 207, 205, 193),
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO MENU
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.menuItem.imageUrl,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (ctx, _, __) => Container(
                  width: 80,
                  height: 80,
                  color: const Color.fromARGB(255, 208, 205, 196),
                  child: const Icon(Icons.broken_image, size: 30),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // INFO MENU + QTY
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.menuItem.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'Rp ${formatRupiah(item.menuItem.price)} / porsi',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // TOMBOL QUANTITY (BARU & DIPERBESAR)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: item.quantity > 1
                              ? () {
                                  setState(() {
                                    item.quantity--;
                                  });
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.remove,
                              size: 22,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            item.quantity.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.add,
                              size: 22,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // HAPUS ITEM + HARGA TOTAL
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                ),
                Text(
                  'Rp ${formatRupiah(item.totalPrice)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ======================
  // CHECKOUT SECTION
  // ======================
  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 85, 72, 72).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Harga',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  'Rp ${formatRupiah(totalPrice)}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        cartItems: cartItems,
                        totalPrice: totalPrice,
                      ),
                    ),
                  );
                },
                style: AppStyles.primaryButtonStyle,
                child: Text(
                  'Lanjut ke Pembayaran',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
