import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart'; // Pastikan file constants.dart ada

class ApiService {
  
  // --- 1. HELPER: Mengambil Token & User ---
  
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // MEMPERBAIKI EROR: getUserName
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    // Mengambil nama user yang disimpan saat login
    return prefs.getString('name') ?? prefs.getString('user_name'); 
  }

  // --- 2. MENU (Home Screen) ---

  // MEMPERBAIKI EROR: getMenu
  Future<List<dynamic>> getMenu() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/menu'));
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // Cek apakah respon dibungkus 'data' atau langsung list
        if (json is Map && json.containsKey('data')) {
          return json['data'];
        } else if (json is List) {
          return json;
        }
      }
    } catch (e) {
      print("Error Get Menu: $e");
    }
    return [];
  }

  // --- 3. RESERVASI (Reservation Form & History) ---

  // MEMPERBAIKI EROR: createReservation
  Future<bool> createReservation({
    required String tglReservasi, 
    required String jamMulai,     
    required int jmlOrg,
    String? catatan,
  }) async {
    final token = await getToken();
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/reservations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Butuh token login
        },
        body: jsonEncode({
          'tgl_reservasi': tglReservasi,
          'jam_mulai': jamMulai,
          'jml_org': jmlOrg,
          'catatan': catatan,
        }),
      );

      // Sukses jika status 200 (OK) atau 201 (Created)
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Error Create Reservation: $e");
      return false;
    }
  }

  // MEMPERBAIKI EROR: getMyReservations
  Future<List<dynamic>> getMyReservations() async {
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/reservations'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // Sesuaikan dengan respon backend (biasanya ada di dalam key 'data')
        return json['data'] ?? [];
      }
    } catch (e) {
      print("Error Get My Reservations: $e");
    }
    return [];
  }
}