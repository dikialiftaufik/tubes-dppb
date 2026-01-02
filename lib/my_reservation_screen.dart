import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'models.dart';
import 'services/api_service.dart';

class MyReservationScreen extends StatefulWidget {
  final int initialIndex;
  const MyReservationScreen({super.key, this.initialIndex = 0});

  @override
  State<MyReservationScreen> createState() => _MyReservationScreenState();
}

class _MyReservationScreenState extends State<MyReservationScreen> {
  late Future<List<dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = ApiService().getReservations().then((List<Reservation> list) {
      return list.map((Reservation e) => {
        'id': e.id,
        'status': e.status,
        'tanggal': e.date,
        'jam_mulai': e.time,
        'jumlah_orang': e.guestCount,
        'catatan': e.notes,
        'nomor_meja': e.tableNumber,
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reservasi Saya', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [Tab(text: 'Berlangsung'), Tab(text: 'Riwayat')],
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada reservasi"));

            final all = snapshot.data!;
            final active = all.where((e) => ['pending', 'confirmed', 'diproses'].contains(e['status'].toString().toLowerCase())).toList();
            final history = all.where((e) => ['completed', 'cancelled', 'selesai', 'batal'].contains(e['status'].toString().toLowerCase())).toList();

            return TabBarView(children: [_buildList(active), _buildList(history)]);
          },
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
            title: Text("Reservasi #${item['id']} - ${item['nama_pemesan'] ?? ''}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            subtitle: Text("${item['tanggal']} | ${item['jam_mulai']} | ${item['jumlah_orang']} Org"),
            trailing: Chip(
              label: Text(item['status'].toString().toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white)),
              backgroundColor: item['status'] == 'pending' ? Colors.orange : (item['status'] == 'confirmed' ? Colors.green : Colors.grey),
            ),
          ),
        );
      },
    );
  }
}