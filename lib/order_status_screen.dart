import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'models.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  // Dummy order data
  final List<Order> orders = [
    Order(
      id: 'ORD-001',
      items: [
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
      ],
      status: 'confirmed', // 'pending', 'confirmed', 'completed', 'cancelled'
      deliveryAddress: 'Jl. Merdeka No. 123, Yogyakarta',
      paymentMethod: 'transfer',
      totalPrice: 70000 + 10000, // subtotal + ongkir
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Order(
      id: 'ORD-002',
      items: [
        CartItem(
          menuItem: MenuItem(
            id: '2',
            name: 'Sate Sapi',
            category: 'Sate',
            meat: 'Sapi',
            price: 45000,
            description: 'Sate daging sapi premium dengan bumbu tradisional',
            imageUrl: 'assets/sate_sapi.png',
          ),
          quantity: 1,
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
          quantity: 2,
        ),
      ],
      status: 'completed',
      deliveryAddress: 'Jl. Merdeka No. 123, Yogyakarta',
      paymentMethod: 'qris',
      totalPrice: 45000 + 84000 + 10000,
      orderDate: DateTime.now().subtract(const Duration(days: 5)),
      completedDate: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            'Pesanan Saya',
            style: GoogleFonts.poppins(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Aktif'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(
              orders.where((o) => o.status != 'completed').toList(),
              isEmpty: orders.where((o) => o.status != 'completed').isEmpty,
            ),
            _buildOrderList(
              orders.where((o) => o.status == 'completed').toList(),
              isEmpty: orders.where((o) => o.status == 'completed').isEmpty,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orderList, {bool isEmpty = false}) {
    if (isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pesanan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orderList[index]);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.secondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusLabel(order.status),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),

            // Items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                order.items.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index != order.items.length - 1 ? 8 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${order.items[index].menuItem.name} x${order.items[index].quantity}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      Text(
                        'Rp ${order.items[index].totalPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),

            // Order Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Dipesan: ${_formatDate(order.orderDate)}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Payment Method
            Row(
              children: [
                Icon(
                  order.paymentMethod == 'transfer'
                      ? Icons.account_balance
                      : Icons.qr_code,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Pembayaran: ${order.paymentMethod == 'transfer' ? 'Transfer Bank' : 'QRIS'}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Total
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    'Rp ${order.totalPrice.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Detail Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _showOrderDetail(order);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Lihat Detail',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return 'Tidak Diketahui';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showOrderDetail(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Detail Pesanan ${order.id}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Status', _getStatusLabel(order.status)),
                _buildDetailRow('Alamat', order.deliveryAddress),
                _buildDetailRow(
                  'Pembayaran',
                  order.paymentMethod == 'transfer'
                      ? 'Transfer Bank'
                      : 'QRIS',
                ),
                _buildDetailRow('Total', 'Rp ${order.totalPrice.toStringAsFixed(0)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Tutup',
                style: GoogleFonts.poppins(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
