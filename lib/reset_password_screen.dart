import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';
import 'constants.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialToken;

  const ResetPasswordScreen({super.key, this.initialEmail, this.initialToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController _emailController;
  late TextEditingController _tokenController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  
  // State Visibilitas untuk masing-masing field
  bool _isTokenVisible = false;           // Default tersembunyi
  bool _isPasswordVisible = false;        // Default tersembunyi
  bool _isConfirmPasswordVisible = false; // Default tersembunyi

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
  }

  void _handleReset() async {
    // Validasi
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password baru wajib diisi')));
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konfirmasi password tidak cocok')));
      return;
    }

    setState(() => _isLoading = true);
    
    // Panggil API
    bool success = await _apiService.resetPassword(
      _emailController.text,
      _tokenController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Password berhasil diubah! Silakan login dengan password baru."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text("Login Sekarang"),
            )
          ],
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal reset password. Pastikan Token valid.')),
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
            Text(
              "Langkah Terakhir",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
            const SizedBox(height: 8),
            Text(
              "Silakan masukkan token yang Anda terima dan buat kata sandi baru.",
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // --- Field Email (READ ONLY) ---
            TextField(
              controller: _emailController,
              readOnly: true, // Tidak bisa diedit
              style: TextStyle(color: Colors.grey[700]), // Text agak abu
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
              obscureText: !_isTokenVisible, // Token tersembunyi by default
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
                  : Text("Simpan Password", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}