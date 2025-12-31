import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'constants.dart';
import 'services/api_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackController = TextEditingController(); // Menggunakan nama controller yang konsisten
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  
  // Data Dropdown
  String? _selectedCategory;
  final List<String> _categories = ['Fasilitas', 'Pelayanan', 'Menu', 'Umum'];

  // File Gambar
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // --- Logic Pilih Gambar ---
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, 
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // --- Logic Hapus Gambar ---
  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  // --- Logic Kirim Feedback ---
  void _sendFeedback() async {
    // 1. Validasi Input
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih kategori masukan")),
      );
      return;
    }
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi pesan tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 2. Panggil API
    bool success = await _apiService.sendFeedback(
      _selectedCategory!,
      _feedbackController.text,
      _imageFile
    );

    setState(() => _isLoading = false);

    // 3. Handle Response
    if (success && mounted) {
      // Tampilkan Alert Sukses
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 70),
                const SizedBox(height: 16),
                Text(
                  "Terkirim!",
                  style: GoogleFonts.poppins(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Masukan Anda berhasil disimpan ke sistem kami.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Tutup Dialog
                      Navigator.pop(context); // Kembali ke Menu Sebelumnya
                    },
                    child: Text("OK", style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mengirim feedback. Pastikan koneksi aman."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Kirim Masukan", 
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Kami Mendengarkan Anda",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
            const SizedBox(height: 8),
            Text(
              "Bantu kami meningkatkan kualitas restoran dengan masukan Anda.",
              style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),

            // 1. Dropdown Kategori
            Text("Kategori", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: Text("Pilih Kategori", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, style: GoogleFonts.poppins()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            
            const SizedBox(height: 20),

            // 2. Text Area Pesan
            Text("Pesan", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: "Tulis kritik & saran Anda di sini...",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. Upload Foto
            Text("Bukti Foto (Opsional)", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            
            if (_imageFile == null)
              // State Belum Ada Foto
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    // PERBAIKAN: Mengganti dashed menjadi solid
                    border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid), 
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo_outlined, color: Colors.grey, size: 40),
                      const SizedBox(height: 8),
                      Text("Ketuk untuk upload foto", style: GoogleFonts.poppins(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else
              // State Sudah Ada Foto (Preview)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 40),

            // 4. Tombol Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Text(
                      "Kirim Masukan", 
                      style: GoogleFonts.poppins(
                        fontSize: 16, 
                        fontWeight: FontWeight.w600, 
                        color: Colors.white
                      ),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}