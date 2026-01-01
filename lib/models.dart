// Lokasi: lib/models.dart

class MenuItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  final String meat; // Tambahan untuk filter jenis daging (jika ada)

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.meat = '', // Default string kosong agar aman
  });

  // Opsional: Helper untuk convert dari JSON jika mau dipindah dari service
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'].toString(),
      name: json['nama_menu'] ?? 'Tanpa Nama',
      category: json['kategori'] ?? 'Umum',
      description: json['deskripsi'] ?? '',
      price: double.tryParse(json['harga'].toString()) ?? 0,
      imageUrl: json['foto'] ?? '',
      meat: json['jenis_daging'] ?? '',
    );
  }
}