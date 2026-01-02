// ========================
// MODELS - The Komars App
// ========================
import 'constants.dart';

// Helper function untuk format Rupiah dengan titik pemisah ribuan
String formatRupiah(double number) {
  return number.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );
}

// Menu Item Model
// Database columns: id, nama, foto, harga, stok, bahan, kalori, kategori, deskripsi
class MenuItem {
  final int id;
  final String name;
  final String category; // kategori from DB
  final String meat; // bahan from DB
  final double price;
  final String description;
  final String imageUrl;
  final bool isAsset;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.meat,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.isAsset = false,
  });

  String get formattedPrice => 'Rp ${formatRupiah(price)}';

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final String name = json['nama'] ?? json['name'] ?? '';
    String? imageUrl = json['foto'] != null && json['foto'].toString().isNotEmpty
          ? '${AppConstants.imageUrl}${json['foto']}' 
          : null;
    bool isAsset = false;

    // Fallback ke assets jika imageUrl kosong atau jika nama menu cocok dengan daftar asset
    final lowerName = name.toLowerCase();
    if (lowerName.contains('sate ayam')) {
      imageUrl = 'lib/assets/sateayam.jpg';
      isAsset = true;
    } else if (lowerName.contains('sate kambing')) {
      imageUrl = 'lib/assets/satekambing.jpg';
      isAsset = true;
    } else if (lowerName.contains('sate sapi')) {
      imageUrl = 'lib/assets/satesapi.jpg';
      isAsset = true;
    } else if (lowerName.contains('tongseng ayam')) {
      imageUrl = 'lib/assets/tongsengayam.jpg';
      isAsset = true;
    } else if (lowerName.contains('tongseng kambing')) {
      imageUrl = 'lib/assets/tongsengkambing.jpg';
      isAsset = true;
    } else if (lowerName.contains('tongseng sapi')) {
      imageUrl = 'lib/assets/tongsengsapi.jpg';
      isAsset = true;
    } else if (lowerName.contains('nasi goreng')) {
      imageUrl = 'lib/assets/nasigoreng.jpg';
      isAsset = true;
    } else if (lowerName.contains('tengkleng kambing')) {
      imageUrl = 'lib/assets/tengklengkambing.jpg';
      isAsset = true;
    } else if (lowerName.contains('tongseng kering sapi')) {
      imageUrl = 'lib/assets/tongsengkeringsapi.jpg';
      isAsset = true;
    }

    return MenuItem(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: name,
      category: json['kategori'] ?? json['category'] ?? '',
      meat: json['bahan'] ?? json['meat'] ?? '',
      price: (json['harga'] ?? json['price'] ?? 0).toDouble(),
      description: json['deskripsi'] ?? json['description'] ?? '',
      imageUrl: imageUrl ?? '',
      isAsset: isAsset,
    );
  }
}

// Cart Item Model
class CartItem {
  final int id;
  final MenuItem menuItem;
  int quantity;

  CartItem({
    required this.id,
    required this.menuItem,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.price * quantity;
  String get formattedTotalPrice => 'Rp ${formatRupiah(totalPrice)}';

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Mencoba mengambil data menu dari 'menu', 'id_menu', atau langsung dari json
    final menuData = json['menu'] ?? json['id_menu'] ?? json;
    
    return CartItem(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      menuItem: MenuItem.fromJson(menuData is Map<String, dynamic> ? menuData : {}),
      quantity: json['jumlah'] ?? json['quantity'] ?? 1,
    );
  }
}

// Order Model
// Database columns: id_pesanan, id_reservasi, id_user, id_kasir, tanggal, total_hrg, status_pesanan, status_pembayaran
class Order {
  final int id;
  final String orderCode;
  final List<OrderItem> items;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.orderCode,
    required this.items,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.orderDate,
  });

  String get formattedTotalPrice => 'Rp ${formatRupiah(totalPrice)}';

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];
    if (json['detail_pesanan'] != null) {
      orderItems = (json['detail_pesanan'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList();
    } else if (json['items'] != null) {
      orderItems = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList();
    }

    // Get ID from either id_pesanan or id
    int orderId = 0;
    if (json['id_pesanan'] != null) {
      orderId = json['id_pesanan'] is int ? json['id_pesanan'] : int.parse(json['id_pesanan'].toString());
    } else if (json['id'] != null) {
      orderId = json['id'] is int ? json['id'] : int.parse(json['id'].toString());
    }

    return Order(
      id: orderId,
      orderCode: 'ORD-$orderId',
      items: orderItems,
      status: json['status_pesanan'] ?? json['status'] ?? 'pending',
      paymentStatus: json['status_pembayaran'] ?? 'pending',
      totalPrice: (json['total_hrg'] ?? json['total_harga'] ?? json['total_price'] ?? 0).toDouble(),
      orderDate: json['tanggal'] != null 
          ? DateTime.parse(json['tanggal']) 
          : (json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now()),
    );
  }
}

// Order Item (detail_pesanan)
class OrderItem {
  final int id;
  final String menuName;
  final int quantity;
  final double price;
  final double subtotal;

  OrderItem({
    required this.id,
    required this.menuName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  String get formattedPrice => 'Rp ${formatRupiah(price)}';
  String get formattedSubtotal => 'Rp ${formatRupiah(subtotal)}';

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final qty = json['jumlah'] ?? json['quantity'] ?? 1;
    final prc = (json['harga'] ?? json['price'] ?? 0).toDouble();
    
    return OrderItem(
      id: json['id'] is int ? json['id'] : int.parse((json['id'] ?? 0).toString()),
      menuName: json['menu']?['nama'] ?? json['nama_menu'] ?? json['menu_name'] ?? '',
      quantity: qty is int ? qty : int.parse(qty.toString()),
      price: prc,
      subtotal: (json['subtotal'] ?? (prc * qty)).toDouble(),
    );
  }
}

// Reservation Model
class Reservation {
  final int id;
  final String tableNumber;
  final String date;
  final String time;
  final int guestCount;
  final String status;
  final String? notes;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.tableNumber,
    required this.date,
    required this.time,
    required this.guestCount,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      tableNumber: json['nomor_meja']?.toString() ?? '',
      date: json['tanggal'] ?? '',
      time: json['waktu'] ?? '',
      guestCount: json['jumlah_tamu'] ?? 1,
      status: json['status'] ?? 'pending',
      notes: json['catatan'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
}
