import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AudioRecordingHandler {
  final AudioRecorder _recorder = AudioRecorder(); // ✅ Correct class for v6.1.2

  Future<String> startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw Exception('Microphone permission not granted');
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/txn_${DateTime.now().millisecondsSinceEpoch}.m4a';

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 16000,
    );

    await _recorder.start(config, path: path);
    return path;
  }

  Future<String?> stopRecording() async {
    return await _recorder.stop();
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }

  // ✅ Add this method here 👇
  Future<String?> transcribeAudio(String filePath) async {
    final file = File(filePath);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:3000/api/transcribe'), // For Android Emulator
    );

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType('audio', 'm4a'),
    ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('Transcription: $responseBody');
      return responseBody;
    } else {
      throw Exception('Failed to transcribe: ${response.statusCode}');
    }
  }
}
