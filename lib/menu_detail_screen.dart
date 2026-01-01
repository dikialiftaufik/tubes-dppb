import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'models.dart';

class MenuDetailScreen extends StatefulWidget {
  final MenuItem menuItem;
  const MenuDetailScreen({super.key, required this.menuItem});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  int _quantity = 1;
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final menu = widget.menuItem;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: menu.imageUrl.startsWith('http')
                  ? Image.network(menu.imageUrl, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: Colors.grey))
                  : Image.asset(menu.imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(menu.name, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(currencyFormatter.format(menu.price), style: GoogleFonts.poppins(fontSize: 20, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text("Deskripsi", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  Text(menu.description.isEmpty ? "Tidak ada deskripsi" : menu.description, style: GoogleFonts.poppins(color: Colors.grey[600])),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: Row(
          children: [
            IconButton(onPressed: () => setState(() => _quantity > 1 ? _quantity-- : null), icon: const Icon(Icons.remove_circle_outline)),
            Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add_circle_outline)),
            const Spacer(),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur Tambah ke Keranjang belum terhubung API"), backgroundColor: Colors.orange));
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                child: Text("Tambah - ${currencyFormatter.format(menu.price * _quantity)}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}