import 'package:flutter/material.dart';
import '../services/parse_service.dart';
import 'package:hack_this_fall_25/services/firestore_services.dart';
import 'package:hack_this_fall_25/model/Transaction_model.dart';

class ConfirmTranscriptionScreen extends StatefulWidget {
  const ConfirmTranscriptionScreen({super.key});

  @override
  State<ConfirmTranscriptionScreen> createState() => _ConfirmTranscriptionScreenState();
}

class _ConfirmTranscriptionScreenState extends State<ConfirmTranscriptionScreen> {
  late TextEditingController _controller;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final text = args?['transcription'] as String? ?? '';
    _controller = TextEditingController(text: text);
  }

  Future<void> _onConfirm() async {
    setState(() => _saving = true);

    try {
      // Parse transcription text into structured data
      final parsed = ParseService.parseTransaction(_controller.text);

      // Convert parsed data into Transaction model
      final txn = Transaction(
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: parsed['productId'] ?? '',
        type: parsed['type'] ?? 'sale',
        quantity: (parsed['quantity'] as num?)?.toInt() ?? 0,
        total: (parsed['total'] as num?)?.toDouble() ?? 0.0,
        createdAt: DateTime.now(),
        source: 'voice',
      );

      // Save transaction to Firestore
      await FirestoreService.saveTransaction(txn);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction saved')),
      );

      Navigator.popUntil(context, ModalRoute.withName('/'));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Transcription')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Transcription',
              ),
            ),
            const SizedBox(height: 12),
            if (_saving) const CircularProgressIndicator(),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saving ? null : _onConfirm,
              child: const Text('Confirm & Save'),
            ),
          ],
        ),
      ),
    );
  }
}
