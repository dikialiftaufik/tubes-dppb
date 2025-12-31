import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk clipboard
import 'services/api_service.dart';
import 'reset_password_screen.dart';
import 'constants.dart';

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
    setState(() => _isLoading = true);
    
    // Call API
    String? token = await _apiService.forgotPassword(_emailController.text);
    
    setState(() => _isLoading = false);

    if (token != null && mounted) {
      // Logic Testing: Copy token ke clipboard atau tampilkan dialog
      Clipboard.setData(ClipboardData(text: token));
      
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Token Diterima (Mode Debug)"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Token reset password telah dibuat."),
              const SizedBox(height: 10),
              SelectableText(token, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Token telah disalin ke clipboard. Silakan tempel di halaman selanjutnya."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
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
              child: const Text("Lanjut ke Reset Password"),
            )
          ],
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email tidak ditemukan.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("Masukkan email Anda untuk menerima token reset password."),
            const SizedBox(height: 20),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: _isLoading ? const CircularProgressIndicator() : const Text("Kirim Permintaan", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}