import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'models.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'transfer'; // 'transfer' atau 'qris'
  String _selectedAddress = 'Jl. Merdeka No. 123, Yogyakarta'; // Default address

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
          'Checkout',
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Summary
            _buildSection(
              title: 'Ringkasan Pesanan',
              child: Column(
                children: List.generate(
                  widget.cartItems.length,
                  (index) => _buildOrderItem(widget.cartItems[index], index),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Delivery Address
            _buildSection(
              title: 'Alamat Pengiriman',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedAddress,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan untuk mengubah alamat pengiriman',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment Method
            _buildSection(
              title: 'Metode Pembayaran',
              child: Column(
                children: [
                  _buildPaymentOption(
                    value: 'transfer',
                    label: 'Transfer Bank',
                    icon: Icons.account_balance,
                    description: 'Transfer ke rekening kami',
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentOption(
                    value: 'qris',
                    label: 'QRIS',
                    icon: Icons.qr_code,
                    description: 'Scan kode QRIS',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Price Details
            _buildSection(
              title: 'Detail Harga',
              child: Column(
                children: [
                  _buildPriceRow(
                    label: 'Subtotal',
                    price: widget.totalPrice,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Colors.grey[300]),
                  ),
                  _buildPriceRow(
                    label: 'Ongkir',
                    price: 10000,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Colors.grey[300]),
                  ),
                  _buildPriceRow(
                    label: 'Total Pembayaran',
                    price: widget.totalPrice + 10000,
                    isBold: true,
                    isLarge: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Confirm Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog();
                },
                style: AppStyles.primaryButtonStyle.copyWith(
                  minimumSize:
                      MaterialStateProperty.all(const Size.fromHeight(50)),
                ),
                child: Text(
                  'Konfirmasi Pesanan',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildOrderItem(CartItem item, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: index != widget.cartItems.length - 1 ? 12 : 0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.restaurant,
                size: 24,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.quantity} x Rp ${item.menuItem.price.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
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
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String label,
    required IconData icon,
    required String description,
  }) {
    final isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[50],
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required double price,
    bool isBold = false,
    bool isLarge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isLarge ? 14 : 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: AppColors.secondary,
          ),
        ),
        Text(
          'Rp ${price.toStringAsFixed(0)}',
          style: GoogleFonts.poppins(
            fontSize: isLarge ? 14 : 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? AppColors.primary : AppColors.secondary,
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Pesanan',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin dengan pesanan ini?\n\nMetode pembayaran: ${_selectedPaymentMethod == 'transfer' ? 'Transfer Bank' : 'QRIS'}\nTotal: Rp ${(widget.totalPrice + 10000).toStringAsFixed(0)}',
            style: GoogleFonts.poppins(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pesanan Anda telah dikonfirmasi!',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
                // Pop to home after delay
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                });
              },
              style: AppStyles.primaryButtonStyle,
              child: Text(
                'Konfirmasi',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
