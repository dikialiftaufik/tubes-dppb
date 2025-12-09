import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy
    final TextEditingController nameController = TextEditingController(
      text: "Diki Alif Taufik",
    );
    final TextEditingController emailController = TextEditingController(
      text: "diki@example.com",
    );
    final TextEditingController phoneController = TextEditingController(
      text: "+62 812 3456 7890",
    );
    final TextEditingController passwordController = TextEditingController(
      text: "password123",
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0, // Membuat judul berdekatan dengan icon back
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
          padding: const EdgeInsets.fromLTRB(
            24,
            10,
            24,
            40,
          ), // Padding bawah ekstra
          child: Column(
            children: [
              // --- Avatar Section (Tanpa Icon Pensil) ---
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              // --- Tombol Edit Profil (Kecil di bawah avatar) ---
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary, // Warna Orange (bukan hitam)
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

              // --- Form Data (Disabled) ---
              _buildReadOnlyField(
                "Nama Lengkap",
                nameController,
                Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildReadOnlyField(
                "Email",
                emailController,
                Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              _buildReadOnlyField(
                "Nomor Telepon",
                phoneController,
                Icons.phone_outlined,
              ),
              const SizedBox(height: 16),
              _buildReadOnlyField(
                "Kata Sandi",
                passwordController,
                Icons.lock_outline,
                isObscure: true,
              ),

              // --- SPACING KOSONG SETARA 1 FIELD ---
              // Memberi jarak sebelum tombol logout
              const SizedBox(height: 60),

              // --- Divider Pemisah ---
              const Divider(color: Colors.grey, thickness: 0.5),
              const SizedBox(height: 24),

              // --- Tombol Keluar (Logout) ---
              // Diletakkan di sini (dalam scroll) agar aman untuk BottomBar nanti
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Kembali ke halaman Login
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) =>
                          false, 
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

  Widget _buildReadOnlyField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isObscure = false,
  }) {
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
          readOnly: true, // Form disabled
          obscureText: isObscure,
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
            filled: true,
            fillColor:
                Colors.grey[50], // Background abu-abu menandakan disabled
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12,
            ),
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
