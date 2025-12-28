import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'constants.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // State Variables
  String? _selectedCategory;
  final TextEditingController _detailController = TextEditingController();
  bool _isAnonymous = false;
  
  // State untuk Foto
  XFile? _pickedImage; 
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    "Pelayanan",
    "Fasilitas",
    "Rasa & Kualitas",
    "Kebersihan",
    "Lainnya"
  ];

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  // --- LOGIKA UPLOAD FOTO ---
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto berhasil dipilih")),
          );
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengambil gambar: $e"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  // --- LOGIKA SUBMIT ---
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                const SizedBox(height: 12),
                Text("Masukan Diterima", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Terima kasih telah membantu kami menjadi lebih baik.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 12),
                if (_pickedImage != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.image, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "1 Foto dilampirkan",
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[800]),
                        ),
                      ],
                    ),
                  )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _detailController.clear();
                    _selectedCategory = null;
                    _isAnonymous = false;
                    _pickedImage = null;
                  });
                },
                child: Text("Tutup", style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: AppColors.primary, 
        elevation: 0,
        centerTitle: false,
        titleSpacing: 24,
        title: Text(
          "Beri Masukan",
          style: GoogleFonts.poppins(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 20, 
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Text(
                "Kami mendengarkan Anda",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Silakan sampaikan kritik & saran terkait pengalaman Anda di restoran kami.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // --- 1. Category Dropdown ---
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Pilih Kategori",
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                dropdownColor: Colors.white,
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category, style: GoogleFonts.poppins()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) => value == null ? "Wajib memilih kategori" : null,
              ),
              const SizedBox(height: 20),

              // --- 2. Detail Input ---
              TextFormField(
                controller: _detailController,
                maxLines: 5,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  hintText: "Ceritakan pengalamanmu secara detail...",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  labelText: "Detail Masukan",
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Detail masukan tidak boleh kosong";
                  }
                  if (value.trim().length < 10) {
                    return "Mohon isi detail lebih lengkap (min. 10 karakter)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- 3. Photo Evidence UI ---
              if (_pickedImage == null) 
                InkWell(
                  onTap: _pickImage, 
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[400]!, 
                        style: BorderStyle.solid, // PERBAIKAN: Menggunakan solid
                        width: 1.5
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 32, color: Colors.grey[600]),
                        const SizedBox(height: 8),
                        Text(
                          "Ketuk untuk Upload Foto (Opsional)",
                          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              else 
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                        image: DecorationImage(
                          image: FileImage(File(_pickedImage!.path)), 
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: _removeImage,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                
              const SizedBox(height: 20),

              // --- 4. Privacy Option ---
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                title: Text(
                  "Kirim sebagai anonim",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.secondary),
                ),
                subtitle: Text(
                  "Identitas Anda tidak akan ditampilkan ke publik.",
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                ),
                value: _isAnonymous,
                onChanged: (bool value) => setState(() => _isAnonymous = value),
              ),
              const SizedBox(height: 32),

              // --- 5. Submit Button ---
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: AppStyles.primaryButtonStyle,
                  child: Text(
                    "Kirim Masukan",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}