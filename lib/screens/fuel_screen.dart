import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../widgets/common_widgets.dart';

class FuelScreen extends StatelessWidget {
  const FuelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final s = provider.selectedStation;
    if (s == null) return const SizedBox.shrink();
    
    final activeVehicle = provider.activeVehicle;
    final allFuels = fuels[s.id] ?? [];
    final fList = (activeVehicle?.type == 'motor')
        ? allFuels.where((f) => f.type == 'bensin').toList()
        : allFuels;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => context.read<AppProvider>().setStep(AppStep.station),
        ),
        title: Text('Pilih Bensin (${s.name})', style: const TextStyle(color: Colors.white)),
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
          itemCount: fList.length,
          itemBuilder: (context, index) {
            final f = fList[index];
            final priceFormatted = currencyFormat.format(f.price);
            return FadeSlideIn(
              delay: Duration(milliseconds: 20 + index * 40),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(
                    f.name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  subtitle: Text(
                    '${f.ratingType} ${f.octane} · $priceFormatted/Liter',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark.withValues(alpha: 0.7)),
                  ),
                  trailing: const Icon(LucideIcons.chevronRight, color: AppColors.primaryDark),
                  onTap: () => context.read<AppProvider>().selectFuel(f),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
