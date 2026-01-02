import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'services/api_service.dart';
import 'home_screen.dart';
import 'menu_screen.dart';
import 'feedback_screen.dart';
import 'dart:async';

class MyReservationScreen extends StatefulWidget {
  final int initialIndex;
  const MyReservationScreen({super.key, this.initialIndex = 0});

  @override
  State<MyReservationScreen> createState() => _MyReservationScreenState();
}

class _MyReservationScreenState extends State<MyReservationScreen> with TickerProviderStateMixin {
  late int _selectedIndex;
  late Future<List<dynamic>> _dataFuture;
  TabController? _tabController;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex == 1 ? 3 : 1;
    _loadData();
    if (_selectedIndex == 1 || _selectedIndex == 3) {
      _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
    }
    // Auto-refresh setiap 30 detik
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _refreshData());
  }

  void _loadData() {
    _dataFuture = ApiService().getMyReservations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _loadData();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if ((index == 1 || index == 3) && _tabController == null) {
        _tabController = TabController(length: 2, vsync: this, initialIndex: index == 3 ? 1 : 0);
      } else if (index != 1 && index != 3) {
        _tabController?.dispose();
        _tabController = null;
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    PreferredSizeWidget? appBar;

    if (_selectedIndex == 1 || _selectedIndex == 3) {
      appBar = AppBar(
        title: const Text('Reservasi Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: 'Berlangsung'), Tab(text: 'Riwayat')],
        ),
      );
      body = FutureBuilder<List<dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada reservasi"));

          final all = snapshot.data!;
          final active = all.where((e) => ['confirmed', 'diproses', 'diterima'].contains(e['status'].toString().toLowerCase())).toList();
          final history = all.where((e) => ['pending', 'completed', 'cancelled', 'selesai', 'batal'].contains(e['status'].toString().toLowerCase())).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(onRefresh: _refreshData, child: _buildList(active)),
              RefreshIndicator(onRefresh: _refreshData, child: _buildList(history))
            ],
          );
        },
      );
    } else {
      switch (_selectedIndex) {
        case 0:
          body = const MenuScreen();
          break;
        case 2:
          body = const HomeScreen();
          break;
        case 4:
          body = const FeedbackScreen();
          break;
        default:
          body = const Center(child: Text("Halaman tidak ditemukan"));
      }
      appBar = null;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      body: body,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_available),
              label: 'Berlangsung',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback),
              label: 'Feedback',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  Widget _buildList(List<dynamic> data) {
    if (data.isEmpty) return const Center(child: Text("Kosong"));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text("Reservasi #${item['id']} - ${item['nama_pemesan'] ?? 'User'}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            subtitle: Text("${item['tgl_reservasi'] ?? item['tanggal'] ?? 'Tanggal tidak tersedia'} | ${item['jam_mulai'] ?? 'Jam tidak tersedia'} | ${item['jml_org'] ?? item['jumlah_orang'] ?? 0} Org"),
            trailing: Chip(
              label: Text((item['status'] ?? 'unknown').toString().toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white)),
              backgroundColor: item['status'] == 'pending' ? Colors.orange : ((item['status'] == 'confirmed' || item['status'] == 'diterima') ? Colors.green : Colors.grey),
            ),
          ),
        );
      },
    );
  }
}