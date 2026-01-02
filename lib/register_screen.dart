import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk mengambil input text
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); 
  
  final ApiService _apiService = ApiService();
  bool _isLoading = false; // Untuk loading state
  bool _isObscure = true; // Untuk sembunyikan password
  bool _isObscureConfirm = true; // Untuk sembunyikan konfirmasi password

  // Fungsi untuk menangani proses registrasi
  void _handleRegister() async {
    // 1. Validasi Input Kosong
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi!'))
      );
      return;
    }

    // 2. Validasi Kesamaan Password
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak cocok!'))
      );
      return;
    }

    setState(() => _isLoading = true);

    // 3. Panggil API Register
    bool success = await _apiService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    // 4. Cek Hasil
    if (success && mounted) {
      // Tampilkan Dialog Sukses (Konsisten dengan Feedback Screen)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Agar dialog tidak memenuhi layar
            children: [
              // Ikon Ceklis Besar
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 70),
              const SizedBox(height: 16),
              
              Text(
                "Berhasil",
                style: GoogleFonts.poppins(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                "Akun berhasil dibuat! Silakan login.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              
              // Tombol OK
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    Navigator.pop(context); // Kembali ke Login Screen
                  },
                  child: Text(
                    "Login Sekarang", 
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi Gagal. Email mungkin sudah terpakai.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Daftar Akun", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ratakan teks ke kiri
          children: [
            // --- HEADER TEXT ---
            Text(
              "Buat Akun Baru",
              style: GoogleFonts.poppins(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: AppColors.secondary
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Silakan lengkapi data diri Anda untuk bergabung dengan kami.",
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            // --------------------------------------

            // Input Nama
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            
            // Input Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            
            // Input Password
            TextField(
              controller: _passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Input Konfirmasi Password
            TextField(
              controller: _confirmPasswordController,
              obscureText: _isObscureConfirm,
              decoration: InputDecoration(
                labelText: "Konfirmasi Password",
                prefixIcon: const Icon(Icons.verified_user_outlined), 
                suffixIcon: IconButton(
                  icon: Icon(_isObscureConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Daftar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Text(
                      "Daftar", 
                      style: GoogleFonts.poppins(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      )
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}