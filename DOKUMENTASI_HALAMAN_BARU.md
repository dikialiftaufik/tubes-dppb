# The Komars - Dokumentasi Halaman Baru

## Ringkasan Halaman-Halaman Baru

Aplikasi The Komars telah diperbarui dengan fitur-fitur baru berikut:

### 1. **Menu Screen (Diperbarui)** 
📁 File: `lib/menu_screen.dart`

**Fungsi:**
- Menampilkan semua menu dalam grid dengan filter kategori
- Pengguna dapat memilih kategori: Semua, Sate, atau Tongseng
- Setiap menu menunjukkan nama, jenis daging, dan harga
- Responsive untuk mobile dan tablet

**Menu Tersedia:**
- **Sate Ayam** - Rp 35.000
- **Sate Sapi** - Rp 45.000
- **Sate Kambing** - Rp 50.000
- **Tongseng Ayam** - Rp 32.000
- **Tongseng Sapi** - Rp 42.000
- **Tongseng Kambing** - Rp 48.000

**Fitur:**
- ✅ Filter kategori dengan FilterChip
- ✅ GridView responsive (2 kolom untuk mobile, 3 untuk tablet)
- ✅ Icon shopping cart di AppBar untuk akses ke Cart
- ✅ Tap menu untuk melihat detail

---

### 2. **Menu Detail Screen**
📁 File: `lib/menu_detail_screen.dart`

**Fungsi:**
- Menampilkan detail lengkap dari menu yang dipilih
- Pengguna dapat menambah/mengurangi jumlah porsi
- Menampilkan harga total dan deskripsi

**Fitur:**
- ✅ Large image placeholder
- ✅ Nama, kategori, dan jenis daging
- ✅ Deskripsi menu
- ✅ Harga per porsi
- ✅ Quantity selector (+ / -)
- ✅ Tampilan total harga
- ✅ Tombol "Tambah ke Keranjang" dengan feedback SnackBar
- ✅ Responsive design

---

### 3. **Cart Screen**
📁 File: `lib/cart_screen.dart`

**Fungsi:**
- Menampilkan semua item yang ada di keranjang
- Pengguna dapat mengubah jumlah atau menghapus item
- Menampilkan total harga
- Navigasi ke checkout

**Fitur:**
- ✅ List item dengan quantity controls
- ✅ Hapus item dengan tombol X
- ✅ Summary harga dengan live calculation
- ✅ Empty state ketika keranjang kosong
- ✅ Tombol "Lanjut ke Pembayaran"
- ✅ Responsive layout

---

### 4. **Checkout Screen**
📁 File: `lib/checkout_screen.dart`

**Fungsi:**
- Ringkasan pesanan sebelum pembayaran
- Pilih alamat pengiriman
- Pilih metode pembayaran
- Tampilkan detail harga lengkap

**Fitur:**
- ✅ Ringkasan pesanan dengan detail item
- ✅ Alamat pengiriman (dapat diubah)
- ✅ Opsi pembayaran: Transfer Bank atau QRIS
- ✅ Detail harga: Subtotal, Ongkir (Rp 10.000), Total
- ✅ Konfirmasi pesanan dengan dialog
- ✅ Responsive design
- ✅ Feedback snackbar setelah order

---

### 5. **Order Status Screen (Pesanan Saya)**
📁 File: `lib/order_status_screen.dart`

**Fungsi:**
- Menampilkan pesanan aktif dan riwayat pesanan
- Tampilkan status pesanan dengan warna berbeda
- Detail pesanan dapat dilihat dalam dialog

**Tab:**
- **Aktif**: Pesanan dengan status Pending atau Confirmed
- **Riwayat**: Pesanan yang sudah Completed atau Cancelled

**Status Pesanan:**
- 🟠 **Menunggu Konfirmasi** (Pending)
- 🔵 **Dikonfirmasi** (Confirmed)
- 🟢 **Selesai** (Completed)
- 🔴 **Dibatalkan** (Cancelled)

**Fitur:**
- ✅ Tab view untuk Aktif & Riwayat
- ✅ Status dengan color coding
- ✅ Detail item dalam pesanan
- ✅ Tanggal pesanan
- ✅ Metode pembayaran
- ✅ Total pembayaran
- ✅ Dialog detail pesanan
- ✅ Empty state untuk masing-masing tab

---

### 6. **Profile Screen (Diperbarui)**
📁 File: `lib/profile_screen.dart`

**Fitur Baru:**
- ✅ Tombol "Pesanan Saya" yang navigasi ke Order Status Screen
- ✅ Layout terstruktur dengan divider
- ✅ Tetap mempertahankan semua fitur lama

---

## Data Models

📁 File: `lib/models.dart`

**MenuItem Model:**
```dart
class MenuItem {
  final String id;
  final String name;
  final String category;
  final String meat;
  final double price;
  final String description;
  final String imageUrl;
}
```

**CartItem Model:**
```dart
class CartItem {
  final MenuItem menuItem;
  int quantity;
  double get totalPrice => menuItem.price * quantity;
}
```

**Order Model:**
```dart
class Order {
  final String id;
  final List<CartItem> items;
  final String status;
  final String deliveryAddress;
  final String paymentMethod;
  final double totalPrice;
  final DateTime orderDate;
  final DateTime? completedDate;
}
```

---

## Responsive Design

Semua halaman yang baru telah dioptimalkan untuk:

### ✅ Mobile Portrait
- Grid 2 kolom untuk menu
- Ukuran widget yang pas di layar kecil
- Touch-friendly buttons dan controls

### ✅ Mobile Landscape
- Otomatis adjust layout
- Grid kolom yang sesuai
- Bottom padding untuk area safe

### ✅ Tablet
- Grid 3 kolom untuk menu
- Lebih efisien memanfaatkan ruang
- Text size yang readable

---

## Navigasi Antar Halaman

```
LoginScreen / HomeScreen
    ↓
    ├─→ MenuScreen (dari MainScreen)
    │    └─→ MenuDetailScreen
    │         └─→ CartScreen
    │              └─→ CheckoutScreen
    │
    └─→ ProfileScreen (dari AppBar)
         └─→ OrderStatusScreen
```

---

## UI Konsistensi

Semua halaman baru menggunakan:

- **Color Scheme**: AppColors.primary (Burnt Orange), AppColors.secondary (Charcoal)
- **Font**: Google Fonts Poppins
- **Card Style**: RoundedRectangleBorder dengan radius 12
- **Button Style**: AppStyles.primaryButtonStyle
- **Spacing**: Consistent padding & margin

---

## Testing Checklist

- [ ] Menu Screen: Filter kategori berfungsi
- [ ] Menu Detail: Quantity selector berfungsi
- [ ] Cart: Add/remove/update quantity berfungsi
- [ ] Checkout: Pilih metode pembayaran
- [ ] Order Status: Tab aktif dan riwayat berfungsi
- [ ] Profile: Tombol "Pesanan Saya" navigasi dengan benar
- [ ] Responsive: Test di mobile portrait & landscape
- [ ] UI Consistency: Warna dan font konsisten

---

## Catatan Pengembangan

1. **Dummy Data**: Semua data saat ini adalah dummy. Untuk production, integrasikan dengan API backend.
2. **Payment Processing**: Checkout screen belum terintegrasi dengan payment gateway.
3. **Image Assets**: Placeholder menggunakan Icons. Untuk production, tambahkan image assets actual.
4. **State Management**: Pertimbangkan menggunakan Provider atau Bloc untuk state management yang lebih robust.

---

**Status**: ✅ Ready for Testing
**Last Updated**: December 11, 2025
