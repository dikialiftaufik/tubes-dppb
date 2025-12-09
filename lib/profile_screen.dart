import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State Variables 
  String _name = "Diki Alif Taufik";
  String _email = "diki@example.com";
  String _phone = "+62 812 3456 7890";
  String _password = "password123";
  bool _hasCustomPhoto = false; // Simulasi status foto profil

  // Fungsi untuk navigasi ke Edit dan MENUNGGU data balik
  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: _name,
          currentEmail: _email,
          currentPhone: _phone,
          currentPassword: _password,
        ),
      ),
    );

    // Jika ada data yang dikembalikan (User menekan Simpan)
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _name = result['name'];
        _email = result['email'];
        _phone = result['phone'];
        _password = result['password'];
        
        // Cek jika ada flag foto berubah
        if (result['photoUpdated'] == true) {
          _hasCustomPhoto = !_hasCustomPhoto; // Toggle simulasi foto
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Controller hanya untuk menampilkan teks (Read Only)
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);
    final passwordController = TextEditingController(text: _password);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profil Saya",
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
          child: Column(
            children: [
              // --- Avatar Section ---
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: _hasCustomPhoto ? AppColors.secondary : Colors.grey,
                  // Simulasi perubahan foto: Jika diedit, icon berubah jadi wajah
                  child: Icon(
                    _hasCustomPhoto ? Icons.face : Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- Tombol Edit Profil ---
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: _navigateToEditProfile, // Panggil fungsi async di atas
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    "Edit Profil",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),

              // --- Form Data (Read Only) ---
              _buildReadOnlyField("Nama Lengkap", nameController, Icons.person_outline),
              const SizedBox(height: 16),
              _buildReadOnlyField("Email", emailController, Icons.email_outlined),
              const SizedBox(height: 16),
              _buildReadOnlyField("Nomor Telepon", phoneController, Icons.phone_outlined),
              const SizedBox(height: 16),
              _buildReadOnlyField("Kata Sandi", passwordController, Icons.lock_outline, isObscure: true),

              const SizedBox(height: 60),
              const Divider(color: Colors.grey, thickness: 0.5),
              const SizedBox(height: 24),

              // --- Tombol Keluar ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: Text(
                    "Keluar",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller, IconData icon, {bool isObscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          readOnly: true,
          obscureText: isObscure,
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}