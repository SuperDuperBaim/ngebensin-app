import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../screens/edit_amount_screen.dart';

class HistoryCard extends StatelessWidget {
  final LogEntry entry;
  const HistoryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    DateTime? dateParsed;
    try {
      dateParsed = DateTime.parse(entry.date);
    } catch (_) {}

    final dateStr = dateParsed != null
        ? DateFormat('dd MMM yyyy').format(dateParsed)
        : entry.date;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.olive.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.fuel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${context.read<AppProvider>().getVehicleName(entry.vehicleId)} · ${entry.station} · $dateStr · ${entry.liters.toStringAsFixed(2)} L',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            currencyFormat.format(entry.total),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.priceGreen,
            ),
          ),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical, size: 20, color: AppColors.textDark),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            elevation: 4,
            onSelected: (val) {
              if (val == 'edit') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditAmountScreen(entry: entry),
                  ),
                );
              } else if (val == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.white,
                    title: const Text('Hapus Catatan?', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    content: const Text('Apakah Anda yakin ingin menghapus catatan riwayat bensin ini? Data tidak dapat dikembalikan.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Batal', style: TextStyle(color: AppColors.textDark.withValues(alpha: 0.7))),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          context.read<AppProvider>().deleteLog(entry.id);
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(LucideIcons.edit2, size: 18, color: AppColors.primaryDark),
                    SizedBox(width: 10),
                    Text('Edit', style: TextStyle(color: AppColors.textDark)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 18, color: Color(0xFFD32F2F)),
                    SizedBox(width: 10),
                    Text('Hapus', style: TextStyle(color: Color(0xFFD32F2F))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
