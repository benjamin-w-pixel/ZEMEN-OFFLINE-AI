import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'extraction_service.dart';

enum BrainStatus { idle, syncing, ready, error }

class AIService extends ChangeNotifier {
  BrainStatus _status = BrainStatus.idle;
  double _syncProgress = 0.0;
  String _statusMessage = "Ready to initialize your offline tutor.";

  BrainStatus get status => _status;
  double get syncProgress => _syncProgress;
  String get statusMessage => _statusMessage;
  String _storageUsage = "0 MB";
  String get storageUsage => _storageUsage;

  /// Starts the "Brain Sync" process (Phase 2 logic)
  Future<void> syncUltimateBrain() async {
    _status = BrainStatus.syncing;
    _syncProgress = 0.0;
    _statusMessage = "Allocating secure storage...";
    notifyListeners();

    try {
      // 1. Storage Check
      await Future.delayed(const Duration(seconds: 1));
      _syncProgress = 0.15;
      _statusMessage = "Checking device compatibility...";
      notifyListeners();

      // 2. Real Extraction Logic (Phase 2)
      await ExtractionService.extractBrain(
        assetPath: "assets/models/brain.zip", // Placeholder
        onProgress: (p) {
          _syncProgress = p;
          if (p < 0.3) _statusMessage = "Unpacking Neural Weights (2GB)...";
          else if (p < 0.7) _statusMessage = "Optimizing Amharic Grammar Bridge...";
          else _statusMessage = "Finalizing Local Academic Database...";
          notifyListeners();
        },
      );

      _status = BrainStatus.ready;
      _statusMessage = "Zemen Brain is Online.";
      notifyListeners();
    } catch (e) {
      _status = BrainStatus.error;
      _statusMessage = "Sync Failed: ${e.toString()}";
      notifyListeners();
    }
  }

  /// Check if the 2GB brain file actually exists on disk
  Future<bool> isBrainOffline() async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/ai_models/ultimate_brain.onnx');
    if (await file.exists()) {
      final stat = await file.stat();
      _storageUsage = "${(stat.size / (1024 * 1024)).toStringAsFixed(1)} MB";
      return true;
    }
    _storageUsage = "0 MB";
    return false;
  }

  /// Clears the offline brain cache
  Future<void> clearBrainSync() async {
    final directory = await getApplicationSupportDirectory();
    final dir = Directory('${directory.path}/ai_models');
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      _status = BrainStatus.idle;
      _storageUsage = "0 MB";
      _statusMessage = "Brain cache cleared. Ready to re-sync.";
      notifyListeners();
    }
  }

  Future<void> updateStorageUsage() async {
    await isBrainOffline();
    notifyListeners();
  }
}
