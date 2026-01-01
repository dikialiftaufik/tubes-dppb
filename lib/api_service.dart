// ---------------- MENU (HOME SCREEN) ----------------

  Future<List<dynamic>> getMenu() async {
    try {
      // Menu bersifat public di api.php, jadi tidak perlu token (header auth)
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/menu'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json is Map && json.containsKey('data')) {
          return json['data'];
        }
      }
    } catch (e) {
      print("Get Menu Error: $e");
    }
    return [];
  }

  // ---------------- RESERVASI ----------------

  // 1. Buat Reservasi Baru (Dipakai di Form Reservasi)
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
          'Authorization': 'Bearer $token', // Wajib Login
        },
        body: jsonEncode({
          'tgl_reservasi': tglReservasi,
          'jam_mulai': jamMulai,
          'jml_org': jmlOrg,
          'catatan': catatan, // Jika di database ada kolom catatan/message
        }),
      );

      print("Response Reservasi: ${response.body}"); // Debugging

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Create Reservation Error: $e");
      return false;
    }
  }

  // 2. Ambil Daftar Reservasi (Dipakai di Riwayat)
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
        return json['data']; // Mengembalikan List Reservasi
      }
    } catch (e) {
      print("Get Reservations Error: $e");
    }
    return [];
  }