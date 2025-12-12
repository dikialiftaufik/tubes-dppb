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
        imageUrl: 'assets/sate_ayam.png',
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
        imageUrl: 'assets/tongseng_sapi.png',
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
        centerTitle: false,
        titleSpacing: 0,
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
                // Cart Items List
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
                // Summary & Checkout
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Item Details
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
                  // Quantity Controls
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            onPressed: item.quantity > 1
                                ? () {
                                    setState(() {
                                      item.quantity--;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.remove),
                            iconSize: 14,
                            color: AppColors.primary,
                            disabledColor: Colors.grey[300],
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        SizedBox(
                          width: 28,
                          child: Center(
                            child: Text(
                              item.quantity.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                item.quantity++;
                              });
                            },
                            icon: const Icon(Icons.add),
                            iconSize: 14,
                            color: AppColors.primary,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Total & Delete
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 4),
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
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary
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
            // Checkout Button
            SizedBox(
              height: 50,
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
                style: AppStyles.primaryButtonStyle.copyWith(
                  minimumSize:
                      MaterialStateProperty.all(const Size.fromHeight(50)),
                ),
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
