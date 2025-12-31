import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'constants.dart';
import 'services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String? currentPhotoUrl;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentEmail,
    this.currentPhotoUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  // Password Controller DIHAPUS

  bool _isLoading = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Panggil API Update Profile 
    bool success = await _apiService.updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      password: null, // Kita kirim null karena field password sudah dihapus
      imageFile: _imageFile,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      // --- Menampilkan Alert Dialog Sukses ---
      showDialog(
        context: context,
        barrierDismissible: false, // User wajib menekan tombol OK
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
                  "Berhasil!",
                  style: GoogleFonts.poppins(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Profil Anda telah berhasil diperbarui.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14, 
                    color: Colors.grey
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Tutup Dialog
                      Navigator.pop(context, true); // Kembali ke halaman sebelumnya dengan refresh data
                    },
                    child: Text(
                      "OK", 
                      style: GoogleFonts.poppins(
                        color: Colors.white, 
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
      // ----------------------------------------------------
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui profil.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Profil", style: GoogleFonts.poppins(color: Colors.white)), 
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian Upload Foto ---
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (widget.currentPhotoUrl != null 
                                ? NetworkImage('${AppConstants.imageUrl}/${widget.currentPhotoUrl!}') as ImageProvider 
                                : null),
                        child: (_imageFile == null && widget.currentPhotoUrl == null)
                            ? const Icon(Icons.person, size: 60, color: Colors.grey)
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Ketuk ikon kamera untuk ganti foto",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
              ),
              
              const SizedBox(height: 30),

              // --- Form Fields ---
              
              // Nama Lengkap
              Text("Nama Lengkap", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Masukkan nama anda",
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (val) => val!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              
              const SizedBox(height: 20),

              // Email
              Text("Email", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Masukkan email anda",
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (val) => val!.isEmpty ? 'Email wajib diisi' : null,
              ),

              const SizedBox(height: 40),

              // --- Tombol Simpan ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : Text(
                        "Simpan Perubahan", 
                        style: GoogleFonts.poppins(
                          color: Colors.white, 
                          fontSize: 16, 
                          fontWeight: FontWeight.w600
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
}