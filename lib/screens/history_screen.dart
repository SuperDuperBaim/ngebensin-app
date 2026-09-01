import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../widgets/common_widgets.dart';
import '../widgets/history_card.dart';
import '../services/pdf_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final logs = provider.filteredHistory;

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
                    const Text(
                      'Riwayat',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (logs.isEmpty) {
                          showThemedPopup(
                            context,
                            message: 'Belum ada catatan riwayat nih!\nCatat dulu pengisian bensinmu baru bisa ekspor PDF 📄',
                            icon: LucideIcons.fileX,
                            buttonText: 'Oke, nanti deh!',
                          );
                          return;
                        }
                        PdfService.generateAndExportPdf(
                          username: provider.displayName,
                          vehicle: provider.selectedHistoryVehicleId == 'all'
                              ? 'Semua Kendaraan'
                              : provider.getVehicleName(provider.selectedHistoryVehicleId),
                          logs: logs,
                          vehicleMap: { for (var v in provider.vehicles) v.id: v.name },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.textDark,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      icon: const Icon(LucideIcons.fileText, size: 16),
                      label: const Text('Ekspor PDF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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

                    Text(
                      '${logs.length} catatan · total ${currencyFormat.format(logs.fold(0.0, (s, e) => s + e.total))}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Vehicle Filters Horizontal Scroll
                    SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          AppFilterChip(
                            label: 'Semua Kendaraan',
                            isSelected: provider.selectedHistoryVehicleId == 'all',
                            onTap: () => provider.setHistoryVehicleFilter('all'),
                          ),
                          ...provider.vehicles.map((v) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: AppFilterChip(
                              label: v.name,
                              isSelected: provider.selectedHistoryVehicleId == v.id,
                              onTap: () => provider.setHistoryVehicleFilter(v.id),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Filter Tabs: Semuanya, Mingguan, Bulanan + Sort Dropdown
                    Row(
                      children: [
                        AppFilterChip(
                          label: 'Semua',
                          isSelected: provider.historyFilter == HistoryFilter.all,
                          onTap: () => provider.setHistoryFilter(HistoryFilter.all),
                        ),
                        const SizedBox(width: 8),
                        AppFilterChip(
                          label: 'Mingguan',
                          isSelected: provider.historyFilter == HistoryFilter.weekly,
                          onTap: () => provider.setHistoryFilter(HistoryFilter.weekly),
                        ),
                        const SizedBox(width: 8),
                        AppFilterChip(
                          label: 'Bulanan',
                          isSelected: provider.historyFilter == HistoryFilter.monthly,
                          onTap: () => provider.setHistoryFilter(HistoryFilter.monthly),
                        ),
                        const Spacer(),
                        PopupMenuButton<HistorySort>(
                          initialValue: provider.historySort,
                          onSelected: (sort) => provider.setHistorySort(sort),
                          offset: const Offset(0, 42),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          color: Colors.white,
                          elevation: 4,
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              value: HistorySort.newest,
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.arrowDownNarrowWide,
                                    size: 16,
                                    color: provider.historySort == HistorySort.newest
                                        ? AppColors.primaryDark
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Terbaru',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: provider.historySort == HistorySort.newest
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: HistorySort.oldest,
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.arrowUpNarrowWide,
                                    size: 16,
                                    color: provider.historySort == HistorySort.oldest
                                        ? AppColors.primaryDark
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Terlama',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: provider.historySort == HistorySort.oldest
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: HistorySort.byStation,
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.fuel,
                                    size: 16,
                                    color: provider.historySort == HistorySort.byStation
                                        ? AppColors.primaryDark
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Per SPBU',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: provider.historySort == HistorySort.byStation
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.olive.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.filter, size: 16, color: AppColors.primaryDark),
                                SizedBox(width: 4),
                                Icon(LucideIcons.chevronDown, size: 14, color: AppColors.primaryDark),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // List of History
                    if (logs.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'Tidak ada catatan riwayat.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...logs.map((entry) => HistoryCard(entry: entry)),
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
