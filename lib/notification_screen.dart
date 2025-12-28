import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart'; // Pastikan import ini ada untuk akses AppColors

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Simulasi Data dari Tabel 'notifikasi' database
  // Struktur: id, tipe, judul, pesan, waktu, is_read
  List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "type": "order", // Tipe untuk menentukan icon
      "title": "Pesanan Sedang Disiapkan",
      "message": "Sate Ayam (2 porsi) pesananmu sedang dibakar oleh chef kami.",
      "time": "Baru saja",
      "isRead": false,
    },
    {
      "id": 2,
      "type": "promo",
      "title": "Diskon Spesial Hari Ini!",
      "message": "Dapatkan potongan 20% untuk pembelian Tongseng Sapi minimal 50rb.",
      "time": "1 jam yang lalu",
      "isRead": false,
    },
    {
      "id": 3,
      "type": "system",
      "title": "Selamat Datang di The Komars",
      "message": "Terima kasih telah mendaftar. Nikmati rasa tanpa batas bersama kami!",
      "time": "Kemarin",
      "isRead": true,
    },
    {
      "id": 4,
      "type": "order",
      "title": "Pesanan Selesai",
      "message": "Pesanan #TRX-9988 telah selesai. Silakan berikan ulasan Anda.",
      "time": "2 Hari yang lalu",
      "isRead": true,
    },
  ];

  // Fungsi untuk menandai notifikasi sudah dibaca
  void _markAsRead(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  // Fungsi menghapus notifikasi (Dismissible)
  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notifikasi dihapus"), duration: Duration(seconds: 1)),
    );
  }

  // Helper untuk Icon berdasarkan tipe
  Widget _buildIcon(String type) {
    switch (type) {
      case 'order':
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.receipt_long, color: Colors.orange),
        );
      case 'promo':
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red[50],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.local_offer, color: Colors.red),
        );
      default:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notifications, color: AppColors.primary),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notifikasi",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white),
            tooltip: "Tandai semua dibaca",
            onPressed: () {
              setState(() {
                for (var n in notifications) {
                  n['isRead'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Semua notifikasi ditandai sudah dibaca")),
              );
            },
          )
        ],
      ),

      // --- BODY (ListView) ---
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada notifikasi",
                    style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
              itemBuilder: (context, index) {
                final item = notifications[index];
                
                // Fitur Geser untuk Hapus (Dismissible)
                return Dismissible(
                  key: Key(item['id'].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteNotification(index);
                  },
                  child: InkWell(
                    onTap: () => _markAsRead(index),
                    child: Container(
                      color: item['isRead'] ? Colors.transparent : AppColors.primary.withOpacity(0.05),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Icon
                          _buildIcon(item['type']),
                          
                          const SizedBox(width: 16),
                          
                          // 2. Konten Teks
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: GoogleFonts.poppins(
                                        fontWeight: item['isRead'] ? FontWeight.w600 : FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    // Indikator Titik Merah jika belum dibaca
                                    if (!item['isRead'])
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['message'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['time'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}