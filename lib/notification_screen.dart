import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: FutureBuilder<List<dynamic>>(
        future: _apiService.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey),
                   const SizedBox(height: 10),
                   Text("Belum ada notifikasi", style: GoogleFonts.poppins(color: Colors.grey)),
                 ],
               ),
             );
          }

          final notifications = snapshot.data!;

          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = notifications[index];
              // Pastikan field JSON sesuai dengan database kamu (title, message, created_at)
              final title = item['title'] ?? 'Info'; 
              final message = item['message'] ?? item['pesan'] ?? '-';
              final time = item['created_at'] ?? '';

              return Container(
                color: Colors.white,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.notifications, color: Colors.white, size: 20),
                  ),
                  title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(message, style: GoogleFonts.poppins(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(time, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}