import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Ini yang error sebelumnya
import '../constants.dart';

class ApiService {
  // --- AUTHENTICATION ---

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
        // Simpan data user sederhana jika perlu
        await prefs.setString('userName', data['user']['name']);
        await prefs.setString('userEmail', data['user']['email']);
        return true;
      }
      return false;
    } catch (e) {
      print("Error Login: $e");
      return false;
    }
  }

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
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final token = await getToken();
    try {
       await http.post(
        Uri.parse('${AppConstants.baseUrl}/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      // Ignore error check
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // --- PROFILE ---

  Future<Map<String, dynamic>?> getProfile() async {
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error Get Profile: $e");
    }
    return null;
  }

  // Update Profile dengan support Upload Gambar (Multipart)
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

  // --- NOTIFICATION ---

  Future<List<dynamic>> getNotifications() async {
    final token = await getToken();
    try {
      // Pastikan endpoint backend ini ada, atau ganti dengan return list kosong dulu jika belum ada
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // Sesuaikan dengan format JSON dari API kamu (apakah dibungkus 'data' atau langsung list)
        if (json is Map && json.containsKey('data')) {
            return json['data'];
        } else if (json is List) {
            return json;
        }
      }
    } catch (e) {
      print("Error Notification: $e");
    }
    return [];
  }
}