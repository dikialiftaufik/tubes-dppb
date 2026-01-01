import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class ApiService {
  // --- AUTH & TOKEN ---
  
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  // --- MENU (HOME SCREEN) ---

  Future<List<dynamic>> getMenu() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/menu'));
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
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

  // --- RESERVASI ---

  Future<bool> createReservation({
    required String tglReservasi, // Format: YYYY-MM-DD
    required String jamMulai,     // Format: HH:MM
    required int jmlOrg,
    String? catatan,
  }) async {
    final token = await getToken();
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/reservations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'tgl_reservasi': tglReservasi,
          'jam_mulai': jamMulai,
          'jml_org': jmlOrg,
          'catatan': catatan,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Error Create Reservation: $e");
      return false;
    }
  }

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
        return json['data'];
      }
    } catch (e) {
      print("Error Get My Reservations: $e");
    }
    return [];
  }
}