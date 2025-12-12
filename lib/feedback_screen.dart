import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedCategory;
  final TextEditingController _detailController = TextEditingController();
  bool _isAnonymous = false;
  
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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Masukan Diterima", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: Text("Terima kasih telah membantu kami menjadi lebih baik.", style: GoogleFonts.poppins()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _detailController.clear();
                    _selectedCategory = null;
                    _isAnonymous = false;
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
      
      // [PERBAIKAN KONSISTENSI]
      // Mengubah AppBar agar sesuai dengan gaya HomeScreen (Warna Primary, Teks Putih)
      appBar: AppBar(
        automaticallyImplyLeading: false, // Konsisten: tidak ada tombol back (diurus MainScreen)
        backgroundColor: AppColors.primary, // Konsisten: Warna background Primary
        elevation: 0,
        centerTitle: false,
        titleSpacing: 24,
        title: Text(
          "Beri Masukan",
          style: GoogleFonts.poppins(
            color: Colors.white, // Konsisten: Teks Putih
            fontWeight: FontWeight.bold, // Konsisten: Font Weight
            fontSize: 20, // Konsisten: Ukuran disesuaikan
          ),
        ),
      ),

      // BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  decoration: const InputDecoration(
                    labelText: "Pilih Kategori",
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                  ),
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
                  decoration: const InputDecoration(
                    hintText: "Ceritakan pengalamanmu...",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Detail masukan tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // --- 3. Photo Evidence UI ---
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Upload Foto (Coming Soon)")),
                    );
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!, style: BorderStyle.solid, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 32, color: Colors.grey[600]),
                        const SizedBox(height: 8),
                        Text(
                          "Upload Bukti Foto (Opsional)",
                          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
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
                    "Identitas Anda tidak akan ditampilkan.",
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
                    child: const Text("Kirim Masukan"),
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