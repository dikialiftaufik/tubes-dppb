import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'constants.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _sendFeedback() async {
    if (_feedbackController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    bool success = await _apiService.sendFeedback(_feedbackController.text);
    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Feedback terkirim!")));
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal mengirim feedback.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kirim Masukan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Tulis kritik dan saran Anda...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendFeedback,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Kirim", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}