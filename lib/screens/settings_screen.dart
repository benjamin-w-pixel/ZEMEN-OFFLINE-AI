import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/zemen_theme.dart';
import '../services/performance_service.dart';
import '../services/ai_service.dart';
import '../utils/glass_effect.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final performance = Provider.of<PerformanceService>(context);
    final aiService = Provider.of<AIService>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Brain Health', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: ZemenTheme.satinGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard(
              "Neural Temperature", 
              "${(performance.thermalLevel * 100).toInt()}°C", 
              performance.thermalLevel > 0.7 ? Colors.red : ZemenTheme.satinGold
            ),
            const SizedBox(height: 20),
            const Text("Brain Sync Management", style: TextStyle(color: Colors.white38, fontSize: 13)),
            const SizedBox(height: 15),
            _buildBrainManagement(aiService),
            const SizedBox(height: 30),
            const Text("Performance Mode", style: TextStyle(color: Colors.white38, fontSize: 13)),
            const SizedBox(height: 15),
            _buildModeSelector(performance),
            const Spacer(),
            const Center(
              child: Text(
                "Zemen AI v1.0.0 Stable Build",
                style: TextStyle(color: Colors.white10, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return GlassEffect(
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector(PerformanceService performance) {
    return GlassEffect(
      child: Column(
        children: PerformanceMode.values.map((mode) {
          final isSelected = performance.mode == mode;
          return ListTile(
            onTap: () => performance.setManualMode(mode),
            leading: Icon(
              mode == PerformanceMode.low ? LucideIcons.battery : LucideIcons.zap,
              color: isSelected ? ZemenTheme.satinGold : Colors.white24,
            ),
            title: Text(
              mode.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white38,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected ? const Icon(LucideIcons.check, color: ZemenTheme.satinGold) : null,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBrainManagement(AIService aiService) {
    return GlassEffect(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: const Icon(LucideIcons.database, color: ZemenTheme.satinGold),
          title: const Text("Clear Local Brain Cache", style: TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text("Storage Used: ${aiService.storageUsage}", style: const TextStyle(color: Colors.white24, fontSize: 11)),
          trailing: TextButton(
            onPressed: () => aiService.clearBrainSync(),
            child: const Text("CLEAR", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
