import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';
import 'constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Belum ada notifikasi", style: GoogleFonts.poppins(color: Colors.grey)),
            );
          }

          final notifications = snapshot.data!;

          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.notifications, color: Colors.white),
                ),
                title: Text(notif['judul'] ?? 'Info', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                subtitle: Text(notif['pesan'] ?? '', style: GoogleFonts.poppins()),
                trailing: Text(notif['created_at']?.toString().substring(0, 10) ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
              );
            },
          );
        },
      ),
    );
  }
}