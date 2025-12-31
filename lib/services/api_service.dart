import 'dart:convert';
import 'dart:io'; // PENTING: Untuk File
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart'; // Jika ada model notifikasi
import '../constants.dart';

class ApiService {
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        await prefs.setString('token', data['access_token']);
        
        if (data['user'] != null) {
          await prefs.setString('userName', data['user']['name']);
          await prefs.setString('userEmail', data['user']['email']);
        }
        return true;
      }
      return false;
    } catch (e) {
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
}