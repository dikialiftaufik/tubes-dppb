import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Package untuk format tanggal
import 'constants.dart';
import 'services/api_service.dart'; // Pastikan import service API ada

class ReservationFormScreen extends StatefulWidget {
  const ReservationFormScreen({super.key});

  @override
  State<ReservationFormScreen> createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  // Variable untuk menyimpan tanggal asli (Objek DateTime)
  DateTime? _selectedDateObj;

  String? _selectedPerson;
  final List<String> _personOptions = ['1 Orang', '2 Orang', '3-4 Orang', '5+ Orang'];

  // State untuk loading saat mengirim data
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Otomatis isi nama dari profil user yang login (Opsional, biar UX lebih bagus)
  void _loadUserProfile() async {
    final name = await ApiService().getUserName(); // Pastikan ada getter ini atau ambil dari SharedPreferences manual
    if (name != null) {
      setState(() {
        _nameController.text = name;
      });
    }
  }

  // Fungsi Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateObj = picked;
        // Tampilkan ke User format Indonesia (DD/MM/YYYY)
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Fungsi Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
       builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Format jam agar selalu 2 digit (misal: 09:05)
        final localizations = MaterialLocalizations.of(context);
        // Kita format manual ke HH:mm untuk API (24 jam format lebih aman)
        final String hour = picked.hour.toString().padLeft(2, '0');
        final String minute = picked.minute.toString().padLeft(2, '0');
        _timeController.text = "$hour:$minute";
      });
    }
  }

  // --- IMPLEMENTASI ALERT DIALOG KONFIRMASI ---
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Reservasi',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Pastikan data berikut sudah benar:', style: GoogleFonts.poppins(fontSize: 14)),
                const SizedBox(height: 10),
                Text('Nama: ${_nameController.text}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text('Tanggal: ${_dateController.text}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text('Jam: ${_timeController.text}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text('Jumlah: $_selectedPerson', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup Dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text('Ya, Pesan', style: GoogleFonts.poppins(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup Dialog
                _processReservation(); // Lanjut ke proses simpan ke Database
              },
            ),
          ],
        );
      },
    );
  }

  // --- FUNGSI KIRIM KE DATABASE ---
  void _processReservation() async {
    setState(() {
      _isLoading = true;
    });

    // 1. Parsing Jumlah Orang (Ubah "3-4 Orang" menjadi angka integer)
    int jumlahOrang = 1;
    if (_selectedPerson != null) {
      // Mengambil angka pertama yang ditemukan
      // Contoh: "5+ Orang" -> diambil '5'
      String numberString = _selectedPerson!.replaceAll(RegExp(r'[^0-9]'), ''); 
      if (numberString.isNotEmpty) {
        // Ambil digit pertama saja jika ada range (misal 34 jadi 3), atau ambil semua tergantung logika
        // Logika sederhana: ambil angka dari string
        jumlahOrang = int.tryParse(numberString.substring(0, 1)) ?? 1; 
        if (_selectedPerson!.contains('3-4')) jumlahOrang = 4; // Override manual jika perlu
        if (_selectedPerson!.contains('5+')) jumlahOrang = 6;
      }
    }

    // 2. Format Tanggal untuk API (YYYY-MM-DD)
    // MySQL butuh format YYYY-MM-DD, bukan dd/MM/yyyy
    String tanggalApi = "";
    if (_selectedDateObj != null) {
      tanggalApi = DateFormat('yyyy-MM-dd').format(_selectedDateObj!);
    } else {
      // Fallback jika error (seharusnya tidak terjadi karena validator)
      tanggalApi = DateTime.now().toString().split(' ')[0];
    }

    // 3. Panggil API Service
    bool success = await ApiService().createReservation(
      tglReservasi: tanggalApi,
      jamMulai: _timeController.text, // Pastikan format HH:mm
      jmlOrg: jumlahOrang,
      catatan: _notesController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservasi Berhasil Diajukan! Cek Menu Riwayat.'), 
          backgroundColor: Colors.green
        ),
      );
      // Kembali ke halaman Home
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuat reservasi. Cek koneksi atau login ulang.'), 
          backgroundColor: Colors.red
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Form Reservasi', style: GoogleFonts.poppins(color: AppColors.secondary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               Text(
                'Lengkapi Data Reservasi',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Nama Pemesan (Readonly disarankan jika ambil dari akun login)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Pemesan', prefixIcon: Icon(Icons.person)),
                // readOnly: true, // Uncomment jika nama tidak boleh diedit
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Pilih Tanggal
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(labelText: 'Tanggal', prefixIcon: Icon(Icons.calendar_today)),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Pilih Jam
              TextFormField(
                controller: _timeController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: const InputDecoration(labelText: 'Jam', prefixIcon: Icon(Icons.access_time)),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Jumlah Orang (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedPerson,
                decoration: const InputDecoration(labelText: 'Jumlah Orang', prefixIcon: Icon(Icons.group)),
                items: _personOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedPerson = newValue),
                validator: (value) => value == null ? 'Pilih jumlah orang' : null,
              ),
              const SizedBox(height: 16),

              // Catatan Tambahan
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan Tambahan (Opsional)', 
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Submit
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading 
                    ? null // Disable tombol saat loading
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _showConfirmationDialog();
                        }
                      },
                  style: AppStyles.primaryButtonStyle,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Buat Reservasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}