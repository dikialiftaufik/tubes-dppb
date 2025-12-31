import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'services/api_service.dart';
import 'models/user_model.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'main_screen.dart'; // Import MainScreen untuk tombol back

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  UserModel? _user;
  bool _isLoading = true;

  // Controller untuk field read-only
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    final user = await _apiService.getProfile();
    if (mounted && user != null) {
      setState(() {
        _user = user;
        _nameController.text = user.name;
        _emailController.text = user.email;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToEdit() async {
    if (_user == null) return;
    
    // Navigasi ke Edit Profile dan tunggu hasil kembaliannya
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: _user!.name,
          currentEmail: _user!.email,
          currentPhotoUrl: _user!.profilePhoto,
        ),
      ),
    );

    // Jika result true (ada perubahan), refresh data
    if (result == true) {
      _fetchUserData();
    }
  }

  void _handleLogout() async {
    await _apiService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100], // Warna background sedikit abu agar card terlihat
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        // --- TOMBOL BACK KE HALAMAN UTAMA ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Kembali ke MainScreen (Halaman Utama)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Keluar",
            onPressed: _handleLogout,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- BAGIAN FOTO & HEADER ---
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _user?.profilePhoto != null
                          ? NetworkImage('${AppConstants.imageUrl}/${_user!.profilePhoto}')
                          : null,
                      child: _user?.profilePhoto == null
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tombol Edit Kecil
                  ElevatedButton.icon(
                    onPressed: _navigateToEdit,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text("Edit Profil"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // --- FORM READ ONLY (KARTU INFORMASI) ---
            // Saya bungkus dalam Card agar UI lebih rapi dan UX lebih jelas
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Akun",
                      style: GoogleFonts.poppins(
                        fontSize: 16, 
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary
                      ),
                    ),
                    const Divider(height: 20),
                    _buildInfoRow("Nama Lengkap", _nameController, Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildInfoRow("Email", _emailController, Icons.email_outlined),
                    // Field ROLE sudah dihapus
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk menampilkan data (Read Only)
  Widget _buildInfoRow(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: true, // Tidak bisa diedit disini
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            filled: true,
            fillColor: Colors.grey[50], // Warna background field
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none, // Hilangkan garis border agar clean
            ),
          ),
        ),
      ],
    );
  }
}