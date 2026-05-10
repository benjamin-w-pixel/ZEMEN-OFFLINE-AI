import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

enum PerformanceMode { low, standard, ultra }

class PerformanceService extends ChangeNotifier {
  double _cpuUsage = 0.0;
  double _neuralSpeed = 0.0;
  double _memoryHealth = 98.5;
  double _thermalLevel = 0.45;
  PerformanceMode _mode = PerformanceMode.standard;
  Timer? _updateTimer;

  PerformanceService() {
    _startMonitoring();
  }

  double get cpuUsage => _cpuUsage;
  double get neuralSpeed => _neuralSpeed;
  double get memoryHealth => _memoryHealth;
  double get thermalLevel => _thermalLevel;
  PerformanceMode get mode => _mode;

  void setManualMode(PerformanceMode newMode) {
    _mode = newMode;
    // Adjust metrics based on mode
    switch (_mode) {
      case PerformanceMode.low:
        _thermalLevel = 0.3;
        _neuralSpeed = 45.0;
        break;
      case PerformanceMode.standard:
        _thermalLevel = 0.5;
        _neuralSpeed = 90.0;
        break;
      case PerformanceMode.ultra:
        _thermalLevel = 0.85;
        _neuralSpeed = 150.0;
        break;
    }
    notifyListeners();
  }

  void _startMonitoring() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_mode == PerformanceMode.low) return; // Static in low power mode

      final random = Random();
      // Simulate real-time neural fluctuations
      _cpuUsage = (_mode == PerformanceMode.ultra ? 20.0 : 5.0) + random.nextDouble() * 15.0;
      _memoryHealth = 98.0 + random.nextDouble() * 1.5;
      
      if (_mode == PerformanceMode.standard) {
        _neuralSpeed = 85.0 + random.nextDouble() * 10.0;
        _thermalLevel = 0.45 + random.nextDouble() * 0.1;
      } else if (_mode == PerformanceMode.ultra) {
        _neuralSpeed = 140.0 + random.nextDouble() * 20.0;
        _thermalLevel = 0.8 + random.nextDouble() * 0.15;
      }
      
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
