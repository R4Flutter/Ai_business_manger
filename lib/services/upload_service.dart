import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UploadService {
  static Future<Map<String, dynamic>?> uploadAudio(String filePath) async {
    final file = File(filePath);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:3000/api/transcribe'), // Android Emulator
      // 👉 Replace with your PC IP if testing on a real device
    );

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType('audio', 'm4a'),
    ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('✅ Transcription response: $responseBody');
      return jsonDecode(responseBody);
    } else {
      print('❌ Failed to upload: ${response.statusCode}');
      throw Exception('Failed to transcribe');
    }
  }
}
