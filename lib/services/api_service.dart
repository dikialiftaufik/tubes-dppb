import 'dart:convert';
import 'dart:io'; // PENTING: Untuk File
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart'; // Jika ada model notifikasi
import '../constants.dart';
import '../models.dart';

class ApiService {
  static final List<CartItem> _localCart = [];
  static int _localCartIdCounter = 1;

  // Helper: Ambil Token dari penyimpanan lokal
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Helper: Header HTTP standar dengan Token
  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ---------------- AUTHENTICATION ----------------

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/register'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'role': 'pembeli',
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("Login Status Code: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        await prefs.setString('token', data['access_token']);
        
        if (data['user'] != null) {
          await prefs.setString('userName', data['user']['name']);
          await prefs.setString('userEmail', data['user']['email']);
          await prefs.setInt('userId', data['user']['id']);
        }
        return true;
      }
      return false;
    } catch (e) {
      print("Login Error Exception: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final headers = await getHeaders();
      await http.post(Uri.parse('${AppConstants.baseUrl}/logout'), headers: headers);
    } catch (e) {
      print("Logout Error: $e");
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ---------------- PROFILE ----------------

  Future<UserModel?> getProfile() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/user'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Get Profile Error: $e");
    }
    return null;
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? password,
    File? imageFile,
  }) async {
    final token = await getToken();
    var uri = Uri.parse('${AppConstants.baseUrl}/user/update');

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields['name'] = name;
    request.fields['email'] = email;
    if (password != null && password.isNotEmpty) {
      request.fields['password'] = password;
    }

    if (imageFile != null) {
      var pic = await http.MultipartFile.fromPath('foto_profile', imageFile.path);
      request.files.add(pic);
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("Error Update Profile: $e");
    }
    return false;
  }

  // ---------------- FITUR LAINNYA ----------------

  Future<String?> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; 
      }
    } catch (e) {
      print("Forgot Password Error: $e");
    }
    return null;
  }

  Future<bool> resetPassword(String email, String token, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': password,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Reset Password Error: $e");
      return false;
    }
  }

  // --- UPDATE PENTING: SEND FEEDBACK SESUAI CONTROLLER BARU ---
  Future<bool> sendFeedback(String kategori, String pesan, File? imageFile) async {
    final token = await getToken();
    var uri = Uri.parse('${AppConstants.baseUrl}/feedback');

    // Gunakan MultipartRequest karena ada potensi upload gambar
    var request = http.MultipartRequest('POST', uri);
    
    // Header Wajib
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    // Tambahkan Field Teks (Sesuai nama di Controller Laravel: store)
    request.fields['kategori_masukan'] = kategori;
    request.fields['pesan_masukan'] = pesan;

    // Tambahkan File Gambar (Sesuai nama di Controller: bukti_foto)
    if (imageFile != null) {
      var pic = await http.MultipartFile.fromPath('bukti_foto', imageFile.path);
      request.files.add(pic);
    }

    try {
      var response = await request.send();
      
      // Debugging response
      final respStr = await response.stream.bytesToString();
      print("Feedback Response Code: ${response.statusCode}");
      print("Feedback Response Body: $respStr");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("Feedback Error: $e");
    }
    return false;
  }

  Future<List<dynamic>> getNotifications() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/notifications'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // Pastikan parsing sesuai struktur JSON dari Laravel
        if (json is Map && json.containsKey('data')) {
          return json['data'];
        } else if (json is List) {
          return json;
        }
      }
    } catch (e) {
      print("Notification Error: $e");
    }
    return [];
  }

  // ---------------- MENU ----------------
  
  // Renamed from getMenu to getMenus to match UI
  Future<List<MenuItem>> getMenus() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/menu'), headers: headers);
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> data = [];
        if (json is Map && json.containsKey('data')) {
          data = json['data'];
        } else if (json is List) {
          data = json;
        }
        return data.map((item) => MenuItem.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error Get Menu: $e");
    }
    return [];
  }

  // ---------------- CART ----------------

  Future<List<CartItem>> getCart() async {
    return List.from(_localCart);
  }

  Future<Map<String, dynamic>> addToCart(int menuId, int quantity) async {
    try {
      // Find menu item first (we need the full object)
      final allMenus = await getMenus();
      final menuItem = allMenus.firstWhere((m) => m.id == menuId);

      // Check if already in cart
      int index = _localCart.indexWhere((item) => item.menuItem.id == menuId);
      if (index != -1) {
        _localCart[index].quantity += quantity;
      } else {
        _localCart.add(CartItem(
          id: _localCartIdCounter++,
          menuItem: menuItem,
          quantity: quantity,
        ));
      }
      return {'success': true};
    } catch (e) {
      print("Error Add to Local Cart: $e");
      return {'success': false, 'message': 'Menu tidak ditemukan'};
    }
  }

  Future<bool> updateCartItem(int id, int quantity) async {
    int index = _localCart.indexWhere((item) => item.id == id);
    if (index != -1) {
      _localCart[index].quantity = quantity;
      return true;
    }
    return false;
  }

  Future<bool> removeCartItem(int id) async {
    _localCart.removeWhere((item) => item.id == id);
    return true;
  }

  Future<bool> clearCart() async {
    _localCart.clear();
    return true;
  }

  // ---------------- ORDERS ----------------

  Future<List<Order>> getOrders() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/pesanan'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> ordersData = [];
        if (json is Map && json.containsKey('data')) {
          ordersData = json['data'];
        } else if (json is List) {
          ordersData = json;
        }
        return ordersData.map((item) => Order.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error Get Orders: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>> createOrder({
    required double totalPrice,
    required String paymentStatus,
    required String paymentMethod,
    required List<CartItem> items,
  }) async {
    try {
      final headers = await getHeaders();
      final userId = await getUserId();
      
      final body = jsonEncode({
        'id_user': userId,
        'total_hrg': totalPrice,
        'status_pembayaran': paymentStatus,
        'status_pesanan': 'diproses',
        'metode_pembayaran': paymentMethod,
        'detail_pesanan': items.map((item) => {
          'id_menu': item.menuItem.id,
          'jumlah': item.quantity,
        }).toList(),
      });

      print("Create Order Request: ${AppConstants.baseUrl}/pesanan");
      print("Create Order Body: $body");

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/pesanan'),
        headers: headers,
        body: body,
      );

      print("Create Order Status: ${response.statusCode}");
      print("Create Order Response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      print("Error Create Order: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // ---------------- RESERVATIONS ----------------

  // Renamed from getMyReservations to getReservations to match UI
  // and changed return type to List<Reservation> as expected by HistoryScreen
  Future<List<Reservation>> getReservations() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/reservasi'), headers: headers);
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> data = [];
        if (json is Map && json.containsKey('data')) {
          data = json['data'];
        } else if (json is List) {
          data = json;
        }
        return data.map((item) => Reservation.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error Get Reservations: $e");
    }
    return [];
  }

  // Compatibility wrapper for older screens
  Future<List<dynamic>> getMyReservations() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/reservasi'), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json is Map && json.containsKey('data')) return json['data'];
        if (json is List) return json;
      }
    } catch (e) {
      print("Error Get My Reservations: $e");
    }
    return [];
  }

  Future<bool> createReservation({
    required String tglReservasi,
    required String jamMulai,
    required int jmlOrg,
    required String catatan,
    String? jamSelesai,
  }) async {
    try {
      final headers = await getHeaders();
      final userId = await getUserId();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/reservasi'),
        headers: headers,
        body: jsonEncode({
          'tgl_reservasi': tglReservasi,
          'jam_mulai': jamMulai,
          'jml_org': jmlOrg,
          'catatan': catatan,
          'jam_selesai': jamSelesai,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print("Create Reservation Failed: Status ${response.statusCode}, Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Create Reservation Error: $e");
      return false;
    }
  }

  // ---------------- HELPERS ----------------

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}