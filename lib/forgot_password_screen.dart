import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk fitur Copy Paste
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'services/api_service.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _handleSubmit() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email wajib diisi')));
      return;
    }

    setState(() => _isLoading = true);
    
    // Panggil API
    String? token = await _apiService.forgotPassword(_emailController.text);
    
    setState(() => _isLoading = false);

    if (token != null && mounted) {
      // Auto copy ke clipboard agar presentasi lebih cepat
      Clipboard.setData(ClipboardData(text: token)); 
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.mark_email_read_outlined, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                "Email Terkirim", 
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kami telah mengirimkan kode verifikasi ke email Anda. Silakan masukkan kode berikut untuk mereset kata sandi:",
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              
              // --- TAMPILAN TOKEN PROFESIONAL ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6), // Abu-abu muda
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    SelectableText(
                      token,
                      textAlign: TextAlign.center,
                      // PERBAIKAN: Menggunakan robotoMono, bukan mono
                      style: GoogleFonts.robotoMono( 
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "Kode otomatis disalin ke papan klip",
                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.green),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Lanjut ke layar Reset Password dengan membawa data
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(
                      initialEmail: _emailController.text,
                      initialToken: token,
                    ),
                  ),
                );
              },
              child: Text("Lanjut ke Reset Password", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary)),
            )
          ],
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak ditemukan atau terjadi kesalahan server.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Lupa Password", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reset Kata Sandi",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
            const SizedBox(height: 8),
            Text(
              "Masukkan email yang terdaftar. Kami akan mengirimkan token verifikasi untuk mereset kata sandi Anda.",
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Form Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "contoh@email.com",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Text("Kirim Permintaan", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}