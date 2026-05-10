import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/zemen_theme.dart';
import '../services/ai_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isExtracting = false;
  double progress = 0.0;
  String statusText = "Ready to initialize your offline tutor.";

  void _startExtraction() async {
    final aiService = Provider.of<AIService>(context, listen: false);
    
    // Trigger the real background sync
    aiService.syncUltimateBrain();

    // After extraction is ready, navigate to Home
    aiService.addListener(() {
      if (aiService.status == BrainStatus.ready && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _buildAuraVisual(),
            const SizedBox(height: 40),
            Text(
              'ZEMEN AI',
              style: GoogleFonts.cinzelDecorative(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
            const SizedBox(height: 10),
            Text(
              'Your Ultimate Offline Student Companion',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ).animate().fadeIn(delay: 400.ms),
            const Spacer(),
            Consumer<AIService>(
              builder: (context, aiService, child) {
                if (aiService.status == BrainStatus.syncing) {
                  return _buildExtractionProgress();
                } else {
                  return _buildBrainChoices();
                }
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildAuraVisual() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ZemenTheme.satinGold.withOpacity(isExtracting ? 0.4 : 0.2),
                blurRadius: 60,
                spreadRadius: 20,
              ),
            ],
          ),
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
         .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.25, 1.25), duration: 2.seconds),
        
        Image.asset(
          'assets/images/neon_brain.png',
          height: 130,
          width: 130,
          fit: BoxFit.contain,
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
         .shimmer(duration: 2.seconds, color: Colors.white30)
         .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1), duration: 2.seconds),
      ],
    );
  }

  Widget _buildBrainChoices() {
    return Column(
      children: [
        _brainOption("Standard Tutor", "300MB - Fast & Efficient", LucideIcons.zap, false),
        const SizedBox(height: 15),
        _brainOption("Ultimate Professor", "2GB - Deep AI & Amharic", LucideIcons.award, true),
      ],
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _brainOption(String title, String subtitle, IconData icon, bool isPremium) {
    return GestureDetector(
      onTap: isPremium ? _startExtraction : () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ZemenTheme.subtleGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPremium ? ZemenTheme.satinGold.withOpacity(0.5) : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isPremium ? ZemenTheme.satinGold : Colors.white60),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractionProgress() {
    return Consumer<AIService>(
      builder: (context, aiService, child) {
        return Column(
          children: [
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: aiService.syncProgress,
              backgroundColor: Colors.white10,
              progressColor: ZemenTheme.satinGold,
              barRadius: const Radius.circular(10),
              animation: false,
            ),
            const SizedBox(height: 20),
            Text(
              aiService.statusMessage,
              style: const TextStyle(color: ZemenTheme.satinGold, fontSize: 14),
            ),
          ],
        );
      },
    ).animate().fadeIn();
  }
}
