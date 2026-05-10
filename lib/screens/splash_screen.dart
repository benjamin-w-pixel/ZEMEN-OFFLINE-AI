import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'onboarding_screen.dart';
import '../theme/zemen_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZemenTheme.obsidian,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The Logo Aura
            Stack(
              alignment: Alignment.center,
              children: [
                // Inner glowing aura
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ZemenTheme.satinGold.withOpacity(0.3),
                        blurRadius: 60,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                 .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.3, 1.3), duration: 2.seconds),
                
                // Real Brain Image
                Image.asset(
                  'assets/images/neon_brain.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                 .shimmer(duration: 2.seconds, color: Colors.white30)
                 .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.08, 1.08), duration: 2.seconds),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // The Brand Name
            Text(
              'ZEMEN AI',
              style: GoogleFonts.cinzelDecorative(
                color: Colors.white,
                letterSpacing: 8,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(delay: 500.ms, duration: 1000.ms)
            .blur(begin: const Offset(10, 10), end: const Offset(0, 0)),
            
            const SizedBox(height: 10),
            
            Text(
              'THE FUTURE OF LEARNING',
              style: TextStyle(
                color: ZemenTheme.satinGold.withOpacity(0.5),
                letterSpacing: 2,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            )
            .animate()
            .fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
