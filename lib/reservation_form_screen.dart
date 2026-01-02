import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'my_reservation_screen.dart';

class ReservationFormScreen extends StatefulWidget {
  const ReservationFormScreen({super.key});

  @override
  _ReservationFormScreenState createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _catatanController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TimeOfDay? _endTime; // Tambahkan untuk jam selesai
  int _selectedJmlOrg = 1; // Default jumlah orang
  bool _isLoading = false;
  String _userName = "Memuat..."; // Variabel untuk menampung nama

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Panggil fungsi ambil nama saat layar dibuka
  }

  // Fungsi Ambil Nama dari SharedPreferences
  void _loadUserName() async {
    String? name = await _apiService.getUserName();
    setState(() {
      _userName = name ?? "Tamu";
    });
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        // Hitung jam selesai otomatis 1 jam setelah
        _endTime = TimeOfDay(hour: (picked.hour + 1) % 24, minute: picked.minute);
      });
    }
  }

  void _submitReservation() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih tanggal & jam dulu')));
        return;
      }

      setState(() => _isLoading = true);

      try {
        // Format Data sebelum dikirim (PENTING!)
        String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        // Format jam manual agar jadi "14:30" (bukan TimeOfDay(...))
        String formattedTime = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
        String formattedEndTime = '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';

        bool success = await _apiService.createReservation(
          tglReservasi: formattedDate,
          jamMulai: formattedTime,
          jmlOrg: _selectedJmlOrg,
          catatan: _catatanController.text,
          jamSelesai: formattedEndTime,
        );

        if (!mounted) return;

        setState(() => _isLoading = false);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil Booking!')));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyReservationScreen(initialIndex: 1)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal. Cek Debug Console.')));
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        print('Reservation Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Reservasi")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // MENAMPILKAN NAMA USER DI SINI
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Memesan atas nama: $_userName",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              ListTile(
                title: Text(_selectedDate == null ? 'Pilih Tanggal' : 'Tanggal: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const Divider(),
              ListTile(
                title: Text(_selectedTime == null ? 'Pilih Jam' : 'Jam: ${'${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'}} WIB - Selesai: ${'${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'}} WIB'),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              const Divider(),
              DropdownButtonFormField<int>(
                initialValue: _selectedJmlOrg,
                decoration: const InputDecoration(labelText: 'Jumlah Orang'),
                items: List.generate(4, (index) => index + 1).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value Orang'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedJmlOrg = newValue!;
                  });
                },
                validator: (value) => value == null ? 'Pilih jumlah orang' : null,
              ),
              TextFormField(
                controller: _catatanController,
                decoration: const InputDecoration(labelText: 'Catatan'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitReservation,
                      child: const Text('Kirim Reservasi'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}