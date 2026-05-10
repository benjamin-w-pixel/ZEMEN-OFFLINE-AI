import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/zemen_theme.dart';
import 'screens/splash_screen.dart';
import 'services/ai_service.dart';
import 'services/ai_engine_service.dart';
import 'services/performance_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AIService()),
        ChangeNotifierProvider(create: (_) => AIEngineService()),
        ChangeNotifierProvider(create: (_) => PerformanceService()),
      ],
      child: const ZemenApp(),
    ),
  );
}

class AppState extends ChangeNotifier {
  bool isModelLoaded = false;
  String currentBrain = "None";

  void setModelLoaded(String brainType) {
    isModelLoaded = true;
    currentBrain = brainType;
    notifyListeners();
  }
}

class ZemenApp extends StatelessWidget {
  const ZemenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zemen AI',
      debugShowCheckedModeBanner: false,
      theme: ZemenTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
