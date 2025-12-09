import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class MyReservationScreen extends StatelessWidget {
  const MyReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Reservasi Saya', style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
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
        body: const TabBarView(
          children: [
            _ReservationList(status: 'active'),
            _ReservationList(status: 'history'),
          ],
        ),
      ),
    );
  }
}

class _ReservationList extends StatelessWidget {
  final String status;
  const _ReservationList({required this.status});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final isHistory = status == 'history';
    final itemCount = isHistory ? 5 : 2; 

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
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
                      'Meja No. ${index + 10}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHistory ? Colors.grey[200] : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isHistory ? 'Selesai' : 'Dikonfirmasi',
                        style: GoogleFonts.poppins(
                          color: isHistory ? Colors.grey : AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                _buildRowInfo(Icons.calendar_today, '07 Des 2025'),
                const SizedBox(height: 4),
                _buildRowInfo(Icons.access_time, '19:00 WIB'),
                const SizedBox(height: 4),
                _buildRowInfo(Icons.people, '4 Orang'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRowInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.poppins(color: Colors.grey[800])),
      ],
    );
  }
}