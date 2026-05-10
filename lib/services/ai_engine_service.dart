import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'database_service.dart';
import 'persona_service.dart';

enum EngineStatus { sleeping, loading, thinking, speaking, error }

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class AIEngineService extends ChangeNotifier {
  EngineStatus _status = EngineStatus.sleeping;
  String _lastResponse = "";
  double _ramUsage = 0.0;
  bool _isOnline = false;
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Selam! I am Zemen AI, your offline professor. How can I help you study today?", isUser: false),
  ];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  AIEngineService() {
    _initConnectivity();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final history = await DatabaseService().getMessages();
    if (history.isNotEmpty) {
      _messages.clear();
      _messages.addAll(history);
      notifyListeners();
    }
  }

  EngineStatus get status => _status;
  String get lastResponse => _lastResponse;
  double get ramUsage => _ramUsage;
  bool get isOnline => _isOnline;
  List<ChatMessage> get messages => _messages;

  Future<void> _initConnectivity() async {
    final connectivity = Connectivity();
    final results = await connectivity.checkConnectivity();
    _updateConnectionStatus(results);
    
    _connectivitySubscription = connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool online = !results.contains(ConnectivityResult.none);
    if (_isOnline != online) {
      _isOnline = online;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  /// Sends a prompt to the Hybrid Engine (Online/Offline)
  Future<void> askUltimateBrain(String prompt) async {
    final userMsg = ChatMessage(text: prompt, isUser: true);
    _messages.add(userMsg);
    await DatabaseService().saveMessage(userMsg);
    
    _status = EngineStatus.thinking;
    _lastResponse = "";
    notifyListeners();

    // Wrap with Persona (Phase 3)
    final personaPrompt = PersonaService.wrapWithPersona(prompt);

    try {
      if (_isOnline) {
        await _askOnlineBrain(personaPrompt);
      } else {
        await _askOfflineBrain(personaPrompt);
      }

      // Process with Persona Signature (Phase 3)
      _lastResponse = PersonaService.processResponse(_lastResponse, !_isOnline);

      final responseMsg = ChatMessage(text: _lastResponse, isUser: false);
      _messages.add(responseMsg);
      await DatabaseService().saveMessage(responseMsg);
      
      _status = EngineStatus.speaking;
      notifyListeners();
    } catch (e) {
      _status = EngineStatus.error;
      _lastResponse = "Error: Brain is overloaded. $e";
      _messages.add(ChatMessage(text: _lastResponse, isUser: false));
      notifyListeners();
    }
  }

  Future<void> _askOnlineBrain(String prompt) async {
    _ramUsage = 200.0; // Online uses much less local RAM
    notifyListeners();

    // Mocking an online API call (Since we don't have a real cloud key yet)
    String response = "";
    List<String> mockTokens = [
      "I am connected to the Cloud. 🌐 ",
      "Here is a highly detailed, real-time response for: ",
      "\"$prompt\". ",
      "The answer is calculated using cloud supercomputers."
    ];

    for (var token in mockTokens) {
      await Future.delayed(const Duration(milliseconds: 150));
      response += token;
      _lastResponse = response;
      notifyListeners();
    }
  }

  Future<void> _askOfflineBrain(String prompt) async {
    // Simulated RAM monitoring for the 2GB offline brain
    _ramUsage = 1800.0;
    notifyListeners();

    String response = "";
    List<String> mockTokens = [
      "Selam! ሰላም! 📶 (Offline Mode). ",
      "I am using my local Neural Engine. ",
      "ዛሬ በሂሳብ ትምህርትህ ላይ እንድትዘጋጅ እረዳሃለሁ። ",
      "Based on your profile, ", "I recommend focusing on ",
      "Quadratic Equations tonight."
    ];

    for (var token in mockTokens) {
      await Future.delayed(const Duration(milliseconds: 100));
      response += token;
      _lastResponse = response;
      notifyListeners();
    }
  }
}
