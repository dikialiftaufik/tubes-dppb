import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'services/api_service.dart';

class ReservationFormScreen extends StatefulWidget {
  const ReservationFormScreen({super.key});

  @override
  State<ReservationFormScreen> createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _selectedDateObj;
  String? _selectedPerson;
  bool _isLoading = false;
  
  final List<String> _personOptions = ['1 Orang', '2 Orang', '3-4 Orang', '5+ Orang'];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final name = await ApiService().getUserName();
    if (name != null) setState(() => _nameController.text = name);
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDateObj = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _timeController.text = "$hour:$minute";
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDateObj == null) return;

    setState(() => _isLoading = true);

    // Parsing Jumlah Orang
    int jml = 1;
    if (_selectedPerson != null) {
       final digits = _selectedPerson!.replaceAll(RegExp(r'[^0-9]'), '');
       if (digits.isNotEmpty) jml = int.parse(digits.substring(0, 1));
       if (_selectedPerson!.contains('5+')) jml = 6;
    }

    // Panggil API
    bool success = await ApiService().createReservation(
      tglReservasi: DateFormat('yyyy-MM-dd').format(_selectedDateObj!),
      jamMulai: _timeController.text,
      jmlOrg: jml,
      catatan: _notesController.text,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reservasi Berhasil!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal Reservasi'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Reservasi'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama', icon: Icon(Icons.person)), validator: (v) => v!.isEmpty ? 'Isi nama' : null),
              TextFormField(controller: _dateController, readOnly: true, onTap: () => _selectDate(context), decoration: const InputDecoration(labelText: 'Tanggal', icon: Icon(Icons.calendar_today)), validator: (v) => v!.isEmpty ? 'Pilih tanggal' : null),
              TextFormField(controller: _timeController, readOnly: true, onTap: () => _selectTime(context), decoration: const InputDecoration(labelText: 'Jam', icon: Icon(Icons.access_time)), validator: (v) => v!.isEmpty ? 'Pilih jam' : null),
              DropdownButtonFormField(
                value: _selectedPerson,
                items: _personOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _selectedPerson = v),
                decoration: const InputDecoration(labelText: 'Jumlah Orang', icon: Icon(Icons.group)),
              ),
              TextFormField(controller: _notesController, decoration: const InputDecoration(labelText: 'Catatan', icon: Icon(Icons.note))),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('BUAT RESERVASI'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}