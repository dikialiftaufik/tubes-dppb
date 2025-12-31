class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? 'Notifikasi',
      message: json['message'] as String,
      // Asumsi di DB ada kolom created_at atau tanggal
      createdAt: json['created_at'] as String, 
      isRead: json['is_read'] == 1 || json['is_read'] == true,
    );
  }
}