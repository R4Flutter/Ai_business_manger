import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:hack_this_fall_25/Audio_recorder.dart';
import 'package:hack_this_fall_25/services/upload_service.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({super.key});

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  late final AudioRecordingHandler _recorderHandler;

  String? _filePath;
  bool _isRecording = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // ✅ Instantiate correctly — no alias
    _recorderHandler = AudioRecordingHandler();
  }

  Future<void> _start() async {
    try {
      final path = await _recorderHandler.startRecording();
      setState(() {
        _filePath = path;
        _isRecording = true;
      });
    } catch (e) {
      _showSnack(e.toString());
    }
  }

  Future<void> _stopAndUpload() async {
    final stoppedPath = await _recorderHandler.stopRecording();
    setState(() => _isRecording = false);

    if (stoppedPath != null) {
      setState(() => _isUploading = true);
      try {
        final resp = await UploadService.uploadAudio(stoppedPath);
        setState(() => _isUploading = false);

        if (resp != null && resp['transcription'] != null) {
          Navigator.pushNamed(
            context,
            '/confirm',
            arguments: {
              'transcription': resp['transcription'],
              'filePath': stoppedPath,
            },
          );
        } else {
          _showSnack('No transcription returned');
        }
      } catch (e) {
        setState(() => _isUploading = false);
        _showSnack('Upload failed: ${e.toString()}');
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Transaction')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Stop & Upload' : 'Start Recording'),
              onPressed: _isRecording ? _stopAndUpload : _start,
            ),
            const SizedBox(height: 12),
            if (_isUploading) const CircularProgressIndicator(),
            if (_filePath != null)
              Text(
                'Saved: ${File(_filePath!).path.split(Platform.pathSeparator).last}',
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorderHandler.dispose();
    super.dispose();
  }
}
