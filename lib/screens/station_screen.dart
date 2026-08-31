import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../widgets/common_widgets.dart';

class StationScreen extends StatelessWidget {
  const StationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => context.read<AppProvider>().setStep(AppStep.home),
        ),
        title: const Text('Pilih SPBU', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: stations.length,
          itemBuilder: (context, index) {
            final s = stations[index];
            return FadeSlideIn(
              delay: Duration(milliseconds: 20 + index * 40),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      s.mono,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    s.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  trailing: const Icon(LucideIcons.chevronRight, color: AppColors.primaryDark),
                  onTap: () {
                    final provider = context.read<AppProvider>();
                    final activeVehicle = provider.activeVehicle;
                    if (s.id == 'shell' && activeVehicle?.type == 'motor') {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.white,
                          actionsAlignment: MainAxisAlignment.center,
                          title: const Text(
                            'Bahan Bakar Belum Tersedia',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          content: Text(
                            'SPBU Shell saat ini hanya menyediakan Shell V-Power Diesel.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textDark),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Pilih SPBU Lain', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      provider.selectStation(s);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
