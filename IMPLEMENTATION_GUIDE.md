# The Komars - Implementation Guide

## 📱 Fitur-Fitur Baru yang Sudah Diimplementasikan

### ✅ 1. Menu Screen dengan Grid & Filter
**Lokasi**: `lib/menu_screen.dart`

Fitur:
- Grid layout responsive (2 kolom mobile, 3 kolom tablet)
- Filter kategori: Semua, Sate, Tongseng
- Setiap card menampilkan: Ikon, Nama, Jenis Daging, Harga
- Tap card untuk melihat detail
- Shopping cart icon di AppBar

Menu yang tersedia:
```
Sate Kategori:
├── Sate Ayam (Rp 35.000)
├── Sate Sapi (Rp 45.000)
└── Sate Kambing (Rp 50.000)

Tongseng Kategori:
├── Tongseng Ayam (Rp 32.000)
├── Tongseng Sapi (Rp 42.000)
└── Tongseng Kambing (Rp 48.000)
```

---

### ✅ 2. Menu Detail Screen (Bottom Sheet Alternative)
**Lokasi**: `lib/menu_detail_screen.dart`

Fitur:
- Full screen detail view (dapat diperluas ke bottom sheet jika diperlukan)
- Gambar placeholder besar
- Nama, kategori, dan jenis daging
- Deskripsi produk
- Harga per porsi
- Quantity selector dengan tombol +/-
- Real-time total price calculation
- "Tambah ke Keranjang" dengan SnackBar feedback
- Responsive untuk semua ukuran layar

Layout:
```
┌─────────────────────┐
│  Back Button        │
├─────────────────────┤
│  [LARGE IMAGE]      │
├─────────────────────┤
│  Sate Ayam [Sate]   │
│  Ayam               │
│  Deskripsi: ...     │
│                     │
│  Rp 35.000/porsi    │
│                     │
│  Jumlah Porsi       │
│  [ - ] 1 [ + ]      │
│                     │
│  Total: Rp 35.000   │
│                     │
│  [Tambah ke Cart]   │
└─────────────────────┘
```

---

### ✅ 3. Cart Screen
**Lokasi**: `lib/cart_screen.dart`

Fitur:
- List item keranjang dengan thumbnail
- Quantity controls per item
- Hapus item dengan tombol X
- Live calculation total harga
- Empty state dengan ilustrasi
- Summary footer dengan total
- Button "Lanjut ke Pembayaran"

Item Layout:
```
┌──────────────────────────────┐
│ [IMG] Sate Ayam              │
│       Rp 35.000/porsi        │
│       [ - ] 2 [ + ]          │
│                   Rp 70.000 [X]
└──────────────────────────────┘
```

---

### ✅ 4. Checkout Screen
**Lokasi**: `lib/checkout_screen.dart`

**Sections:**

#### 4.1 Ringkasan Pesanan
- List item dengan quantity dan harga
- Format: Item x Qty = Subtotal

#### 4.2 Alamat Pengiriman
- Card dengan icon lokasi
- Default address: Jl. Merdeka No. 123, Yogyakarta
- Tap untuk mengubah (simulasi)

#### 4.3 Metode Pembayaran
- Radio selection untuk Transfer Bank atau QRIS
- Setiap opsi menampilkan icon dan deskripsi
- Custom radio button styling

#### 4.4 Detail Harga
- Subtotal
- Ongkir (Rp 10.000 fixed)
- Total Pembayaran

#### 4.5 Konfirmasi
- Button "Konfirmasi Pesanan"
- Dialog konfirmasi
- SnackBar feedback
- Auto-pop ke home setelah sukses

Layout Responsiveness:
```
Mobile Portrait:
- Semua section full-width
- Stacked vertical

Mobile Landscape:
- Adjust padding
- Scroll horizontal untuk summary
```

---

### ✅ 5. Order Status Screen (Pesanan Saya)
**Lokasi**: `lib/order_status_screen.dart`

**Tab 1: Aktif**
- Menampilkan pesanan dengan status: Pending, Confirmed
- Setiap card menunjukkan: ID, Status badge, Item list, Tanggal, Total

**Tab 2: Riwayat**
- Menampilkan pesanan yang sudah: Completed, Cancelled
- Layout sama dengan tab Aktif

**Status Colors:**
- 🟠 Pending (Orange)
- 🔵 Confirmed (Blue)
- 🟢 Completed (Green)
- 🔴 Cancelled (Red)

**Order Card Layout:**
```
┌──────────────────────────────┐
│ ORD-001            [Confirmed]│
├──────────────────────────────┤
│ Sate Ayam x2        Rp 70.000 │
│                              │
│ 📅 Dipesan: 07 Des 2025      │
│ 💳 Pembayaran: Transfer Bank  │
├──────────────────────────────┤
│ Total: Rp 80.000             │
│ [Lihat Detail]               │
└──────────────────────────────┘
```

**Detail Dialog:**
- Status
- Alamat pengiriman
- Metode pembayaran
- Total harga

---

### ✅ 6. Profile Screen (Updated)
**Lokasi**: `lib/profile_screen.dart`

**Perubahan:**
- Tambahan tombol "Pesanan Saya" (icon receipt)
- Navigasi ke Order Status Screen
- Divider untuk visual separation
- Tetap mempertahankan Edit Profil dan Logout

Button Order:
```
[📋 Pesanan Saya]  ← Navigasi ke OrderStatusScreen
```

---

## 🎨 Design System

### Color Palette
```dart
AppColors.primary   = Color(0xFFE65100)  // Burnt Orange
AppColors.secondary = Color(0xFF212121)  // Charcoal
AppColors.background= Color(0xFFFAFAFA)  // Off-white
AppColors.surface   = Colors.white       // White
AppColors.error     = Color(0xFFB00020)  // Red
```

### Typography
- Font Family: Google Fonts Poppins
- Headings: w600, w700 (bold)
- Body: w500, w400 (medium, regular)
- Captions: w400 (regular, small)

### Spacing Standards
```dart
8px   - Minimal spacing
12px  - Small elements
16px  - Standard padding
20px  - Large spacing
24px  - Section spacing
32px  - Major sections
```

### Component Sizing
- Card Radius: 12px
- Button Height: 50px
- Small Button: 36px
- Icon Size: 20-24px (action), 40-60px (large)

---

## 📊 Data Flow

```
┌──────────────────┐
│   MenuScreen     │
│  (Grid + Filter) │
└────────┬─────────┘
         │ tap item
         ↓
┌──────────────────┐
│ MenuDetailScreen │
│  (Details)       │
└────────┬─────────┘
         │ add to cart
         ↓
┌──────────────────┐
│   CartScreen     │
│  (Items List)    │
└────────┬─────────┘
         │ checkout
         ↓
┌──────────────────┐
│ CheckoutScreen   │
│ (Payment Info)   │
└────────┬─────────┘
         │ confirm
         ↓
┌──────────────────┐
│ OrderStatusScreen│
│   (History)      │
└──────────────────┘
```

---

## 📱 Responsive Breakpoints

### Mobile Portrait (< 600px)
- Grid: 2 columns
- Full-width containers
- Adjusted padding (16px)
- Standard text size

### Tablet / Mobile Landscape (≥ 600px)
- Grid: 3 columns  
- Side padding: 20-24px
- Slightly larger text
- More whitespace

### Desktop (≥ 900px)
- Grid: 4 columns
- Constrained max-width
- Generous padding
- Large text

---

## 🔄 State Management (Current)

**Type**: StatefulWidget dengan setState

**Data Persistence**:
- CartItems: In-memory (List<CartItem>)
- OrderHistory: Dummy data in OrderStatusScreen
- UserProfile: In-memory di ProfileScreen

**Future Improvements**:
- Implementasi SharedPreferences untuk local persistence
- Provider atau Bloc untuk global state management
- Firebase/Backend API untuk persistence

---

## ⚠️ Known Limitations & Future TODOs

### Current Implementation
1. ✅ UI/UX lengkap dan responsive
2. ✅ Navigation antar halaman
3. ✅ Dummy data untuk demo

### Belum Diimplementasikan (Future)
1. **API Integration**
   - Fetch menu dari backend
   - Save order ke database
   - Fetch order history

2. **Payment Gateway**
   - Integrase Midtrans / Payment provider
   - Handle payment confirmation
   - Generate payment proof

3. **Image Management**
   - Upload gambar menu
   - Image caching
   - Optimize images

4. **Advanced Features**
   - Push notifications untuk order status
   - Real-time order tracking
   - Review & rating system
   - Promo codes & discounts

5. **State Management**
   - Implementasi Provider
   - Global cart state
   - User session management

---

## 🚀 How to Run

```bash
# Clean & get dependencies
flutter clean
flutter pub get

# Run the app
flutter run

# Run dengan specific device
flutter run -d <device-id>
```

---

## 📝 File Structure

```
lib/
├── main.dart                    # Entry point
├── constants.dart               # Colors & Styles
├── models.dart                  # Data models
│
├── auth/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── forgot_password_screen.dart
│   └── reset_password_screen.dart
│
├── menu/
│   ├── menu_screen.dart         # ✅ NEW - Menu grid
│   └── menu_detail_screen.dart  # ✅ NEW - Detail view
│
├── cart/
│   └── cart_screen.dart         # ✅ NEW - Shopping cart
│
├── order/
│   ├── checkout_screen.dart     # ✅ NEW - Checkout
│   └── order_status_screen.dart # ✅ NEW - Order history
│
├── profile/
│   ├── profile_screen.dart      # ✅ UPDATED
│   ├── edit_profile_screen.dart
│   └── feedback_screen.dart
│
└── home/
    ├── home_screen.dart
    ├── main_screen.dart
    └── my_reservation_screen.dart
```

---

**Last Updated**: December 11, 2025  
**Status**: Ready for Testing & Integration  
**Next Phase**: API Integration & Backend Connection
