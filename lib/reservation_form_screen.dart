import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

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
  
  String? _selectedPerson;
  final List<String> _personOptions = ['1 Orang', '2 Orang', '3-4 Orang', '5+ Orang'];

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
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
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
        _timeController.text = picked.format(context);
      });
    }
  }

  // --- IMPLEMENTASI ALERT DIALOG (Sesuai Ketentuan Poin 11c) ---
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
                _processReservation(); // Lanjut ke proses simpan
              },
            ),
          ],
        );
      },
    );
  }

  void _processReservation() {
    // Simulasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reservasi Berhasil Diajukan!'), 
        backgroundColor: Colors.green
      ),
    );
    // Kembali ke halaman Home
    Navigator.pop(context);
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

              // Nama Pemesan
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Pemesan', prefixIcon: Icon(Icons.person)),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Panggil Alert Dialog Konfirmasi
                      _showConfirmationDialog();
                    }
                  },
                  style: AppStyles.primaryButtonStyle,
                  child: const Text('Buat Reservasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}