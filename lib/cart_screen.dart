import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'models.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Dummy cart data (PASTIKAN pakai lib/assets/)
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
      backgroundColor: AppColors.background,
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

  Widget _buildCartItem(int index) {
    final item = cartItems[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // **GAMBAR FIXED — PAKAI Image.asset**
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.menuItem.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (ctx, _, __) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 30),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Informasi Item
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.menuItem.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${item.menuItem.price.toStringAsFixed(0)}/porsi',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Kontrol Quantity
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          iconSize: 14,
                          padding: EdgeInsets.zero,
                          onPressed: item.quantity > 1
                              ? () {
                                  setState(() {
                                    item.quantity--;
                                  });
                                }
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            item.quantity.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          iconSize: 14,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Harga total + tombol hapus
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
                  'Rp ${item.totalPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                  'Rp ${totalPrice.toStringAsFixed(0)}',
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
