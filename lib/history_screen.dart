import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'models.dart';
import 'services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  List<Order> orders = [];
  List<Reservation> reservations = [];
  bool _isLoadingOrders = true;
  bool _isLoadingReservations = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadOrders(),
      _loadReservations(),
    ]);
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoadingOrders = true);
    final data = await _apiService.getOrders();
    if (mounted) {
      setState(() {
        orders = data;
        _isLoadingOrders = false;
      });
    }
  }

  Future<void> _loadReservations() async {
    setState(() => _isLoadingReservations = true);
    final data = await _apiService.getReservations();
    if (mounted) {
      setState(() {
        reservations = data;
        _isLoadingReservations = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Riwayat',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Pesanan'),
              Tab(text: 'Reservasi'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderHistoryTab(),
            _buildReservationHistoryTab(),
          ],
        ),
      ),
    );
  }

  // ==================== ORDER HISTORY TAB ====================
  Widget _buildOrderHistoryTab() {
    if (_isLoadingOrders) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.receipt_long_outlined,
        message: 'Belum ada riwayat pesanan',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.orderCode,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status,
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: _getStatusColor(order.status)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dipesan: ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary),
                      ),
                      Text(
                        order.formattedTotalPrice,
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== RESERVATION HISTORY TAB ====================
  Widget _buildReservationHistoryTab() {
    if (_isLoadingReservations) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filter status yang sudah menjadi riwayat
    final historyList = reservations.where((r) => 
      ['completed', 'cancelled', 'selesai', 'batal'].contains(r.status.toLowerCase())
    ).toList();

    if (historyList.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_month_outlined,
        message: 'Belum ada riwayat reservasi',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReservations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final item = historyList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text("Reservasi #${item.id}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              subtitle: Text("${item.date} | ${item.time} | ${item.guestCount} Org"),
              trailing: Chip(
                label: Text(item.status.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white)),
                backgroundColor: item.status.toLowerCase() == 'completed' || item.status.toLowerCase() == 'selesai' ? Colors.green : Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'confirmed':
      case 'diproses': return Colors.blue;
      case 'completed':
      case 'selesai': return Colors.green;
      case 'cancelled':
      case 'dibatalkan': return Colors.red;
      default: return Colors.grey;
    }
  }
}
