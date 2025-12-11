// Menu Item Model
class MenuItem {
  final String id;
  final String name;
  final String category; // 'Sate' atau 'Tongseng'
  final String meat; // 'Ayam', 'Sapi', 'Kambing'
  final double price;
  final String description;
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.meat,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
}

// Cart Item Model
class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.price * quantity;
}

// Order Model
class Order {
  final String id;
  final List<CartItem> items;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String deliveryAddress;
  final String paymentMethod; // 'transfer', 'qris'
  final double totalPrice;
  final DateTime orderDate;
  final DateTime? completedDate;

  Order({
    required this.id,
    required this.items,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.totalPrice,
    required this.orderDate,
    this.completedDate,
  });
}
