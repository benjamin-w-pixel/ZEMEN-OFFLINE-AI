import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme/zemen_theme.dart';
import '../services/performance_service.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(context),
            _buildQuickActions(context),
            _buildSubjectGrid(context),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        backgroundColor: ZemenTheme.satinGold,
        child: const Icon(LucideIcons.messageSquare, color: Colors.black, size: 32),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ሰላም (Selam), Student!',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                    ),
                    Text(
                      'Your Offline Professor is ready. ዝግጁ ነኝ!',
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: ZemenTheme.subtleGray,
                  child: Icon(LucideIcons.user, color: ZemenTheme.satinGold),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Consumer<PerformanceService>(
              builder: (context, perf, child) {
                return Row(
                  children: [
                    _perfMetric("Neural Load", "${perf.cpuUsage.toStringAsFixed(1)}%", LucideIcons.activity),
                    _perfMetric("Brain Speed", "${perf.neuralSpeed.toStringAsFixed(1)} T/s", LucideIcons.zap),
                    _perfMetric("Memory Health", "${perf.memoryHealth.toStringAsFixed(1)}%", LucideIcons.shieldCheck),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _perfMetric(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: ZemenTheme.satinGold),
              const SizedBox(width: 5),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _actionCard(context, "Scan Book", LucideIcons.camera),
            _actionCard(context, "Create Quiz", LucideIcons.fileQuestion),
            _actionCard(context, "Translate", LucideIcons.languages),
            _actionCard(context, "Voice Chat", LucideIcons.mic),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: ZemenTheme.subtleGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: ZemenTheme.satinGold, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectGrid(BuildContext context) {
    final subjects = [
      {
        'name': 'Mathematics',
        'icon': LucideIcons.calculator,
        'color': Colors.blue,
        'image': 'https://images.unsplash.com/photo-1509228468518-180dd4864904?auto=format&fit=crop&w=400&q=80'
      },
      {
        'name': 'Ethio History',
        'icon': LucideIcons.landmark,
        'color': Colors.orange,
        'image': 'https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=400&q=80'
      },
      {
        'name': 'Biology',
        'icon': LucideIcons.dna,
        'color': Colors.green,
        'image': 'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?auto=format&fit=crop&w=400&q=80'
      },
      {
        'name': 'Physics',
        'icon': LucideIcons.atom,
        'color': Colors.purple,
        'image': 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?auto=format&fit=crop&w=400&q=80'
      },
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(25),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.4,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final sub = subjects[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ZemenTheme.subtleGray,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                  image: DecorationImage(
                    image: NetworkImage(sub['image'] as String),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.65),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(sub['icon'] as IconData, color: sub['color'] as Color, size: 32),
                    const Spacer(),
                    Text(
                      sub['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Offline Module',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (index * 100).ms).scale();
          },
          childCount: subjects.length,
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ZemenTheme.subtleGray.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(LucideIcons.layoutGrid, color: ZemenTheme.satinGold),
          const Icon(LucideIcons.bookOpen, color: Colors.white24),
          IconButton(
            icon: const Icon(LucideIcons.settings, color: Colors.white24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
