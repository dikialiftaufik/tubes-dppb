import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'reset_password_screen.dart'; // Import agar bisa navigasi ke Reset Password

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() {
    if (_formKey.currentState!.validate()) {
      // 1. Tampilkan pesan sukses simulasi kirim email
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link reset password telah dikirim ke email Anda'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // 2. Navigasi ke halaman Reset Password
      // (Dalam aplikasi nyata, user biasanya mengklik link dari email, 
      // tapi ini untuk memudahkan demo alur aplikasi)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Konsisten dengan ResetPasswordScreen
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Judul halaman di sebelah tombol back, konsisten dengan ResetPasswordScreen
        title: Text(
          "Lupa Password", 
          style: GoogleFonts.poppins(
            color: AppColors.secondary, 
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Headings Konsisten
                Text(
                  'Reset Password',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masukkan email yang terdaftar. Kami akan mengirimkan instruksi untuk mengatur ulang kata sandi.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),

                // --- Email Field ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter email';
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // --- Send Button ---
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleForgotPassword,
                    style: AppStyles.primaryButtonStyle,
                    child: const Text('Kirim Link'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}