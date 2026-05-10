import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class ExtractionService {
  /// Extracts the compressed AI brain to the device storage.
  static Future<void> extractBrain({
    required String assetPath,
    required Function(double) onProgress,
  }) async {
    try {
      final directory = await getApplicationSupportDirectory();
      final destinationDir = Directory('${directory.path}/ai_models');
      
      if (!await destinationDir.exists()) {
        await destinationDir.create(recursive: true);
      }

      // 1. Load the Asset as Bytes
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      
      // 2. Decode the ZIP
      final archive = ZipDecoder().decodeBytes(bytes);
      
      int totalFiles = archive.length;
      int extractedFiles = 0;

      // 3. Extract each file
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('${destinationDir.path}/$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory('${destinationDir.path}/$filename').create(recursive: true);
        }
        
        extractedFiles++;
        onProgress(extractedFiles / totalFiles);
      }
      
      if (kDebugMode) {
        print("Brain extracted successfully to: ${destinationDir.path}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Extraction Error: $e");
      }
      rethrow;
    }
  }
}
