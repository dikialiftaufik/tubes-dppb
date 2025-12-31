import 'dart:convert';
import 'dart:io'; // PENTING: Diperlukan untuk tipe data File
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
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

  // 1. REGISTER
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
          'role': 'pembeli', // Force role pembeli
        }),
      );
      print("Register Response: ${response.body}"); 
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  // 2. LOGIN
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("Login Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        // Simpan Token
        await prefs.setString('token', data['access_token']);
        
        // Simpan Data User sementara
        if (data['user'] != null) {
          await prefs.setString('userName', data['user']['name']);
          await prefs.setString('userEmail', data['user']['email']);
        }
        return true;
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  // 3. LOGOUT
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

  // 4. GET PROFILE
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

  // 5. UPDATE PROFILE (METHOD YANG SEBELUMNYA HILANG)
  Future<bool> updateProfile({
    required String name,
    required String email,
    String? password,
    File? imageFile,
  }) async {
    final token = await getToken();
    var uri = Uri.parse('${AppConstants.baseUrl}/user/update');

    // Gunakan MultipartRequest untuk upload file
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    // Tambahkan Field Teks
    request.fields['name'] = name;
    request.fields['email'] = email;
    if (password != null && password.isNotEmpty) {
      request.fields['password'] = password;
    }

    // Tambahkan File Gambar (jika ada)
    if (imageFile != null) {
      var pic = await http.MultipartFile.fromPath('foto_profile', imageFile.path);
      request.files.add(pic);
    }

    try {
      var response = await request.send();
      // Periksa status code dari StreamedResponse
      if (response.statusCode == 200) {
        return true;
      } else {
        // Debugging: baca response body jika error
        final respStr = await response.stream.bytesToString();
        print("Update Failed: $respStr");
      }
    } catch (e) {
      print("Error Update Profile: $e");
    }
    return false;
  }

  // ---------------- FITUR LAINNYA ----------------

  // 6. FORGOT PASSWORD
  Future<String?> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      
      print("Forgot Pass Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; 
      }
    } catch (e) {
      print("Forgot Password Error: $e");
    }
    return null;
  }

  // 7. RESET PASSWORD
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

  // 8. SEND FEEDBACK
  Future<bool> sendFeedback(String content) async {
    try {
      final headers = await getHeaders();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/feedback'),
        headers: headers,
        body: jsonEncode({'isi_feedback': content}),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Feedback Error: $e");
      return false;
    }
  }

  // 9. GET NOTIFICATIONS
  Future<List<dynamic>> getNotifications() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/notifications'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
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