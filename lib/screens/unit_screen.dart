import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../widgets/common_widgets.dart';

class UnitScreen extends StatelessWidget {
  const UnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => context.read<AppProvider>().setStep(AppStep.fuel),
        ),
        title: const Text('Pilih Satuan Beli', style: TextStyle(color: Colors.white)),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FadeSlideIn(
              delay: const Duration(milliseconds: 80),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(LucideIcons.banknote, color: AppColors.primaryDark, size: 30),
                  title: const Text(
                    'Beli Berdasarkan Rupiah (Rp)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 16),
                  ),
                  subtitle: Text(
                    'Contoh: Rp 20.000, Rp 50.000',
                    style: TextStyle(color: AppColors.textDark.withValues(alpha: 0.6), fontSize: 13),
                  ),
                  onTap: () => context.read<AppProvider>().selectUnit('rupiah'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeSlideIn(
              delay: const Duration(milliseconds: 160),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(LucideIcons.droplets, color: AppColors.primaryDark, size: 30),
                  title: const Text(
                    'Beli Berdasarkan Liter (L)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 16),
                  ),
                  subtitle: Text(
                    'Contoh: 2 Liter, 4.5 Liter',
                    style: TextStyle(color: AppColors.textDark.withValues(alpha: 0.6), fontSize: 13),
                  ),
                  onTap: () => context.read<AppProvider>().selectUnit('liter'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
