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
              Tab(text: 'Riwayat Pesanan'),
              Tab(text: 'Riwayat Reservasi'),
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

    // Show all orders (database uses: Selesai, diproses, Menunggu Pembayaran, etc.)
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
          return _buildOrderCard(orders[index]);
        },
      ),
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
                  order.orderCode,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.secondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Items summary
            ...order.items.take(2).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${item.menuName} x${item.quantity}',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
              ),
            )),
            if (order.items.length > 2)
              Text(
                '+${order.items.length - 2} item lainnya',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
              ),

            const SizedBox(height: 8),

            // Date & Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(order.orderDate),
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Text(
                  order.formattedTotalPrice,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
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

  // ==================== RESERVATION HISTORY TAB ====================
  Widget _buildReservationHistoryTab() {
    if (_isLoadingReservations) {
      return const Center(child: CircularProgressIndicator());
    }

    final historyReservations = reservations.where((r) => 
      r.status == 'completed' || r.status == 'cancelled'
    ).toList();

    if (historyReservations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_month_outlined,
        message: 'Belum ada riwayat reservasi',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReservations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyReservations.length,
        itemBuilder: (context, index) {
          return _buildReservationCard(historyReservations[index]);
        },
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation) {
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
                  'Meja No. ${reservation.tableNumber}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.secondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: reservation.status == 'completed' 
                        ? Colors.green.withOpacity(0.1) 
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    reservation.status == 'completed' ? 'Selesai' : 'Dibatalkan',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: reservation.status == 'completed' ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Details
            _buildInfoRow(Icons.calendar_today, reservation.date),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.access_time, '${reservation.time} WIB'),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.people, '${reservation.guestCount} Orang'),
            if (reservation.notes != null && reservation.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildInfoRow(Icons.note, reservation.notes!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(color: Colors.grey[800], fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
      case 'completed':
      case 'lunas':
        return Colors.green;
      case 'diproses':
      case 'processing':
        return Colors.blue;
      case 'pending':
      case 'menunggu pembayaran':
        return Colors.orange;
      case 'cancelled':
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
