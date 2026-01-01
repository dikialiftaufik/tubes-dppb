import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Pastikan sudah tambah intl di pubspec.yaml
import 'constants.dart';
import 'services/api_service.dart';

class MyReservationScreen extends StatefulWidget {
  final int initialIndex;

  const MyReservationScreen({super.key, this.initialIndex = 0});

  @override
  State<MyReservationScreen> createState() => _MyReservationScreenState();
}

class _MyReservationScreenState extends State<MyReservationScreen> {
  // Variable untuk menampung Future agar tidak reload terus saat set state
  late Future<List<dynamic>> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _refreshReservations();
  }

  void _refreshReservations() {
    setState(() {
      _reservationsFuture = ApiService().getMyReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Reservasi Saya',
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
              Tab(text: 'Berlangsung'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _reservationsFuture,
          builder: (context, snapshot) {
            // 1. Kondisi Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Kondisi Error
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text("Gagal memuat data", style: GoogleFonts.poppins(color: Colors.grey)),
                    TextButton(
                      onPressed: _refreshReservations,
                      child: const Text("Coba Lagi"),
                    )
                  ],
                ),
              );
            }

            // 3. Kondisi Data Kosong
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text("Belum ada riwayat reservasi", style: GoogleFonts.poppins(color: Colors.grey)),
              );
            }

            final allData = snapshot.data!;

            // 4. Filter Data (Pending/Confirmed vs Completed/Cancelled)
            // Sesuaikan string status dengan database PABW (case insensitive handling)
            final activeList = allData.where((r) {
              String status = (r['status'] ?? '').toString().toLowerCase();
              return status == 'pending' || status == 'confirmed' || status == 'diproses';
            }).toList();

            final historyList = allData.where((r) {
              String status = (r['status'] ?? '').toString().toLowerCase();
              return status == 'completed' || status == 'cancelled' || status == 'selesai' || status == 'batal';
            }).toList();

            return TabBarView(
              children: [
                _ReservationList(data: activeList, isHistory: false, onRefresh: _refreshReservations),
                _ReservationList(data: historyList, isHistory: true, onRefresh: _refreshReservations),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ReservationList extends StatelessWidget {
  final List<dynamic> data;
  final bool isHistory;
  final VoidCallback onRefresh;

  const _ReservationList({
    required this.data, 
    required this.isHistory,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isHistory ? Icons.history : Icons.calendar_today, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              isHistory ? "Tidak ada riwayat lama" : "Tidak ada reservasi aktif",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          
          // Parsing Tanggal dari format YYYY-MM-DD ke format User Friendly
          String formattedDate = item['tanggal'] ?? '-';
          try {
            DateTime dateObj = DateTime.parse(item['tanggal']);
            formattedDate = DateFormat('dd MMM yyyy').format(dateObj);
          } catch (e) {
            // ignore error
          }

          // Warna badge status
          Color statusColor;
          String statusText = (item['status'] ?? '-').toString().toUpperCase();
          
          if (statusText == 'PENDING') {
            statusColor = Colors.orange;
          } else if (statusText == 'CONFIRMED') {
            statusColor = Colors.green;
          } else if (statusText == 'CANCELLED' || statusText == 'BATAL') {
            statusColor = Colors.red;
          } else {
            statusColor = Colors.grey;
          }

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ID: #${item['id']}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withOpacity(0.5)),
                        ),
                        child: Text(
                          statusText,
                          style: GoogleFonts.poppins(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildRowInfo(Icons.calendar_today, formattedDate),
                  const SizedBox(height: 4),
                  _buildRowInfo(Icons.access_time, item['jam_mulai'] ?? '-'),
                  const SizedBox(height: 4),
                  _buildRowInfo(Icons.people, "${item['jumlah_orang']} Orang"),
                  const SizedBox(height: 4),
                  _buildRowInfo(Icons.person, "Pemesan: ${item['nama_pemesan']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRowInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.poppins(color: Colors.grey[800], fontSize: 13)),
        ],
      ),
    );
  }
}