import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'services/api_service.dart';
import 'models/user_model.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'order_status_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    final user = await _apiService.getProfile();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  // --- LOGIKA NAVIGASI EDIT PROFILE ---
  void _navigateToEditProfile() async {
    if (_user == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: _user!.name,
          currentEmail: _user!.email,
          currentPhone: "08123456789", // Placeholder atau ambil dari DB jika sudah ada kolomnya
          currentPassword: "", // Password kosong demi keamanan
          currentPhotoUrl: _user!.profilePhoto, // <--- Parameter ini sekarang sudah valid
        ),
      ),
    );

    // Refresh data jika ada perubahan (result == true)
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

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profil")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Gagal memuat profil"),
              ElevatedButton(onPressed: _fetchUserData, child: const Text("Coba Lagi"))
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Profil Saya", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- Foto Profil ---
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: _user!.profilePhoto != null
                  ? NetworkImage('${AppConstants.imageUrl}/${_user!.profilePhoto}')
                  : null,
              child: _user!.profilePhoto == null
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 16),
            
            Text(
              _user!.name,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _user!.email,
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            
            const SizedBox(height: 24),

            // --- Tombol Edit ---
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _navigateToEditProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Edit Profil", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),

            // --- Menu Lain ---
            ListTile(
              leading: const Icon(Icons.receipt_long, color: AppColors.primary),
              title: const Text("Pesanan Saya"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const OrderStatusScreen())),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Keluar", style: TextStyle(color: Colors.red)),
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }
}