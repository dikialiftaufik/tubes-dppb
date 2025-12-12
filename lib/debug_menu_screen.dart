import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'edit_profile_screen.dart';
import 'feedback_screen.dart';

class DebugMenuScreen extends StatelessWidget {
  const DebugMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Debug Menu (Developer Mode)",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent, // Warna merah agar mencolok bahwa ini mode debug
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pilih Halaman untuk Ditest:",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // 1. Tombol ke Home Screen
            _buildDebugButton(
              context,
              "🏠 Home Screen",
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              ),
            ),

            // 2. Tombol ke Profile Screen
            _buildDebugButton(
              context,
              "👤 Profile Screen",
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
            ),

            // 3. Tombol ke Edit Profile Screen (Dengan Dummy Data)
            _buildDebugButton(
              context,
              "✏️ Edit Profile Screen",
              Colors.purple,
              () {
                // Edit Profile butuh data awal, kita kasih data palsu (dummy)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(
                      currentName: "User Debug",
                      currentEmail: "debug@example.com",
                      currentPhone: "08123456789",
                      currentPassword: "password123",
                    ),
                  ),
                );
              },
            ),

            // 4. Tombol ke Feedback Screen
            _buildDebugButton(
              context,
              "💬 Feedback Screen",
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugButton(
    BuildContext context, 
    String label, 
    Color color, 
    VoidCallback onPressed
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}