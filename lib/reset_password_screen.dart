import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';
import 'constants.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  // Menerima data email dan token dari halaman sebelumnya
  final String? initialEmail;
  final String? initialToken;

  const ResetPasswordScreen({super.key, this.initialEmail, this.initialToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // Controller Text Field
  late TextEditingController _emailController;
  late TextEditingController _tokenController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false; // State untuk loading
  
  // State Visibilitas Password (Toggle Mata)
  bool _isTokenVisible = false;           
  bool _isPasswordVisible = false;        
  bool _isConfirmPasswordVisible = false; 

  @override
  void initState() {
    super.initState();
    // Isi otomatis jika ada data yang dikirim dari halaman sebelumnya
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
  }

  void _handleReset() async {
    // 1. Validasi Input
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password baru wajib diisi'))
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak cocok'))
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // 2. Panggil API Reset Password
    bool success = await _apiService.resetPassword(
      _emailController.text,
      _tokenController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    // 3. Cek Hasil
    if (success && mounted) {
      // Tampilkan Alert Dialog Sukses (Konsisten dengan Register/Feedback)
      showDialog(
        context: context,
        barrierDismissible: false, // User harus tekan tombol Login
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ikon Ceklis Hijau
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
                "Password berhasil diubah! Silakan login dengan password baru.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              
              // Tombol Login Sekarang
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    
                    // Kembali ke Login Screen dan hapus history navigasi sebelumnya
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
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
        const SnackBar(content: Text('Gagal reset password. Pastikan Token valid.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Buat Password Baru", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER TEXT ---
            Text(
              "Langkah Terakhir",
              style: GoogleFonts.poppins(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: AppColors.secondary
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Silakan masukkan token yang Anda terima dan buat kata sandi baru.",
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // --- Field Email (READ ONLY) ---
            // Ditampilkan agar user yakin akun mana yang sedang di-reset
            TextField(
              controller: _emailController,
              readOnly: true, // Tidak bisa diedit
              style: TextStyle(color: Colors.grey[700]), 
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200], // Background abu menandakan read-only
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Field Token ---
            TextField(
              controller: _tokenController,
              obscureText: !_isTokenVisible, // Bisa di-toggle visibility-nya
              decoration: InputDecoration(
                labelText: "Token Reset",
                prefixIcon: const Icon(Icons.vpn_key_outlined),
                suffixIcon: IconButton(
                  icon: Icon(_isTokenVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isTokenVisible = !_isTokenVisible),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // --- Field Password Baru ---
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password Baru",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // --- Field Konfirmasi Password ---
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: "Konfirmasi Password",
                prefixIcon: const Icon(Icons.verified_user_outlined),
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),

            // --- Tombol Simpan ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleReset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Text(
                      "Simpan Password", 
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