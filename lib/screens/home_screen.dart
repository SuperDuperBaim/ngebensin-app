import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../widgets/common_widgets.dart';
import '../widgets/history_card.dart';
import '../widgets/stat_chart_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _visibleHistoryCount = 5;

  void _showVehicleSwitcherDialog(BuildContext context) {
    final provider = context.read<AppProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Tampilan Kendaraan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            // Semua Kendaraan option
            ListTile(
              leading: const Icon(LucideIcons.layoutGrid, color: AppColors.primaryDark),
              title: const Text('Semua Kendaraan', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
              trailing: provider.selectedDashboardVehicleId == 'all'
                  ? const Icon(LucideIcons.check, color: AppColors.primaryDark)
                  : null,
              onTap: () {
                provider.setDashboardVehicleFilter('all');
                Navigator.of(ctx).pop();
              },
            ),
            const Divider(),
            // Vehicles list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: provider.vehicles.length,
                itemBuilder: (context, index) {
                  final v = provider.vehicles[index];
                  final isSelected = provider.selectedDashboardVehicleId == v.id;
                  return ListTile(
                    leading: Icon(
                      v.type == 'mobil' ? LucideIcons.car : LucideIcons.bike,
                      color: AppColors.primaryDark,
                    ),
                    title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    trailing: isSelected ? const Icon(LucideIcons.check, color: AppColors.primaryDark) : null,
                    onTap: () {
                      provider.setDashboardVehicleFilter(v.id);
                      provider.setActiveLoggingVehicle(v.id);
                      Navigator.of(ctx).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Dark Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: SizedBox(
                height: 44,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.greeting,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          provider.displayName,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Vehicle Switcher Pill Button
                    InkWell(
                      onTap: () => _showVehicleSwitcherDialog(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              provider.selectedDashboardVehicleId == 'all'
                                  ? LucideIcons.layoutGrid
                                  : (provider.vehicle == 'mobil' ? LucideIcons.car : LucideIcons.bike),
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              provider.selectedDashboardVehicleId == 'all'
                                  ? 'Semua Kendaraan'
                                  : provider.vehicleName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(LucideIcons.chevronDown, color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Cream Body Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Summary Cards
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 80),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Total Pengeluaran
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.olive.withValues(alpha: 0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'TOTAL PENGELUARAN',
                                      style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textDark.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        currencyFormat.format(provider.totalSpent),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ),
                                    if (provider.firstLogDate != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'Sejak ${provider.firstLogDate}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textDark.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Total Liter
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.olive.withValues(alpha: 0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'TOTAL LITER',
                                      style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textDark.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${provider.totalLiters.toStringAsFixed(1)} L',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    if (provider.firstLogDate != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'Sejak ${provider.firstLogDate}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textDark.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // CTA Catat Isi Bensin
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 200),
                      child: InkWell(
                        onTap: () {
                          if (provider.selectedDashboardVehicleId == 'all') {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => Container(
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                                decoration: const BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Catat bensin untuk kendaraan apa?',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                    ),
                                    const SizedBox(height: 16),
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: provider.vehicles.length,
                                        itemBuilder: (context, index) {
                                          final v = provider.vehicles[index];
                                          return ListTile(
                                            leading: Icon(
                                              v.type == 'mobil' ? LucideIcons.car : LucideIcons.bike,
                                              color: AppColors.primaryDark,
                                            ),
                                            title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                            onTap: () {
                                              provider.setActiveLoggingVehicle(v.id);
                                              Navigator.of(ctx).pop();
                                              provider.setStep(AppStep.station);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            provider.setActiveLoggingVehicle(provider.selectedDashboardVehicleId);
                            provider.setStep(AppStep.station);
                          }
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(LucideIcons.plus, color: AppColors.primaryDark, size: 24),
                              ),
                              const SizedBox(width: 16),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Catat isi bensin',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Tambah catatan baru sekarang',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Statistik SPBU & Bensin Terfavorit
                    if (provider.history.isNotEmpty) ...[
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 300),
                        child: StatChartCard(
                          title: 'SPBU Sering Dikunjungi',
                          icon: LucideIcons.building2,
                          data: provider.stationStats,
                          totalCount: provider.dashboardLogs.length,
                        ),
                      ),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 380),
                        child: StatChartCard(
                          title: 'Bensin Sering Dibeli',
                          icon: LucideIcons.fuel,
                          data: provider.fuelStats,
                          totalCount: provider.dashboardLogs.length,
                        ),
                      ),
                    ],

                    // Section Header: Riwayat Terakhir
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 440),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Riwayat terakhir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          InkWell(
                            onTap: () => provider.setStep(AppStep.history),
                            child: const Row(
                              children: [
                                Text(
                                  'Lihat semua',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // History Items
                    if (provider.dashboardLogs.isEmpty)
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'Belum ada catatan pengisian bensin.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    else ...[
                      ...provider.dashboardLogs.take(_visibleHistoryCount).toList().asMap().entries.map((e) => FadeSlideIn(
                        delay: Duration(milliseconds: e.key < 5 ? 500 + e.key * 80 : 0),
                        child: HistoryCard(entry: e.value),
                      )),
                      if (provider.dashboardLogs.length > _visibleHistoryCount) ...[
                        const SizedBox(height: 8),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 100),
                          child: Center(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _visibleHistoryCount += 10;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryDark,
                                side: BorderSide(color: AppColors.primaryDark.withValues(alpha: 0.3), width: 1.5),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              icon: const Icon(LucideIcons.chevronDown, size: 18),
                              label: Text(
                                'Tampilkan lebih banyak (${provider.dashboardLogs.length - _visibleHistoryCount})',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
