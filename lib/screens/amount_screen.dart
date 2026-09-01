import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../widgets/common_widgets.dart';

class AmountScreen extends StatefulWidget {
  const AmountScreen({super.key});

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumberWithDots(String value) {
    if (value.isEmpty) return '';
    final clean = value.replaceAll('.', '').replaceAll(',', '');
    final numVal = int.tryParse(clean);
    if (numVal == null) return value;
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(numVal);
  }

  void _selectQuickValue(String textVal) {
    _controller.text = textVal;
    _controller.selection = TextSelection.collapsed(offset: textVal.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isRupiah = provider.selectedUnit == 'rupiah';
    final fuel = provider.selectedFuel;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (fuel == null) return const SizedBox.shrink();

    final minPrice = fuel.price; // 1 Liter price
    final maxPrice = fuel.price * 30; // 30 Liters price

    const minLiters = 1.0;
    const maxLiters = 30.0;

    final helperText = isRupiah
        ? 'Minimal ${currencyFormat.format(minPrice)} (1L) · Maksimal ${currencyFormat.format(maxPrice)} (30L)'
        : 'Minimal 1 Liter · Maksimal 30 Liter';

    final hintFormatted = isRupiah
        ? currencyFormat.format(minPrice).replaceAll('Rp ', '')
        : '3.5';

    final rawNominals = [10000, 20000, 30000, 40000, 50000, 75000, 100000];
    final quickNominals = rawNominals.where((v) => v >= minPrice && v <= maxPrice).toList();

    final rawLiters = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 10.0];
    final quickLiters = rawLiters.where((v) => v >= minLiters && v <= maxLiters).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => context.read<AppProvider>().setStep(AppStep.unit),
        ),
        title: Text('Masukkan Nominal (${isRupiah ? 'Rupiah' : 'Liter'})', style: const TextStyle(color: Colors.white)),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: Text(
                  isRupiah ? 'NOMINAL (RUPIAH)' : 'JUMLAH (LITER)',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeSlideIn(
                delay: const Duration(milliseconds: 140),
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  onChanged: (val) {
                    if (isRupiah && val.isNotEmpty) {
                      final formatted = _formatNumberWithDots(val);
                      if (formatted != val) {
                        _controller.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    }
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: hintFormatted,
                    suffixText: isRupiah ? '' : ' Liter',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  helperText,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeSlideIn(
                delay: const Duration(milliseconds: 260),
                child: Text(
                  'OPSI NOMINAL CEPAT',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeSlideIn(
                delay: const Duration(milliseconds: 320),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: isRupiah
                      ? quickNominals.map((nom) {
                          final formatted = _formatNumberWithDots(nom.toString());
                          final chipLabel = 'Rp $formatted';
                          final isSelected = _controller.text == formatted;
                          return ChoiceChip(
                            label: Text(chipLabel),
                            selected: isSelected,
                            selectedColor: AppColors.primaryDark,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textDark,
                            ),
                            side: BorderSide(
                              color: isSelected ? AppColors.primaryDark : AppColors.olive.withValues(alpha: 0.3),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            onSelected: (_) => _selectQuickValue(formatted),
                          );
                        }).toList()
                      : quickLiters.map((lit) {
                          final litStr = lit % 1 == 0 ? lit.toInt().toString() : lit.toString();
                          final chipLabel = '$litStr Liter';
                          final isSelected = _controller.text == litStr;
                          return ChoiceChip(
                            label: Text(chipLabel),
                            selected: isSelected,
                            selectedColor: AppColors.primaryDark,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textDark,
                            ),
                            side: BorderSide(
                              color: isSelected ? AppColors.primaryDark : AppColors.olive.withValues(alpha: 0.3),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            onSelected: (_) => _selectQuickValue(litStr),
                          );
                        }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              FadeSlideIn(
                delay: const Duration(milliseconds: 380),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () async {
                      final cleanStr = _controller.text.replaceAll('.', '').replaceAll(',', '.').trim();
                      final val = double.tryParse(cleanStr);
                      if (val == null) {
                        showValidationPopup(
                          context,
                          title: 'Nominal Tidak Valid',
                          message: 'Silakan masukkan angka nominal pengisian yang valid.',
                        );
                        return;
                      }

                      if (isRupiah) {
                        if (val < minPrice) {
                          showValidationPopup(
                            context,
                            title: 'Nominal Pengisian Kurang',
                            message: 'Minimal pengisian adalah ${currencyFormat.format(minPrice)} (1 Liter).',
                          );
                          return;
                        }
                        if (val > maxPrice) {
                          showValidationPopup(
                            context,
                            title: 'Nominal Melebihi Batas',
                            message: 'Maksimal pengisian adalah ${currencyFormat.format(maxPrice)} (30 Liter).',
                          );
                          return;
                        }
                        final liters = val / fuel.price;
                        await context.read<AppProvider>().confirmEntry(liters: liters, total: val, navigateToSuccess: false);
                        if (context.mounted) {
                          showSuccessBottomSheet(
                            context,
                            fuelName: fuel.name,
                            liters: liters,
                            total: val,
                            onNavigate: () => context.read<AppProvider>().setStep(AppStep.home),
                          );
                        }
                      } else {
                        if (val < minLiters) {
                          showValidationPopup(
                            context,
                            title: 'Jumlah Liter Kurang',
                            message: 'Minimal pengisian adalah 1 Liter.',
                          );
                          return;
                        }
                        if (val > maxLiters) {
                          showValidationPopup(
                            context,
                            title: 'Jumlah Liter Melebihi Batas',
                            message: 'Maksimal pengisian adalah 30 Liter.',
                          );
                          return;
                        }
                        final total = val * fuel.price;
                        await context.read<AppProvider>().confirmEntry(liters: val, total: total, navigateToSuccess: false);
                        if (context.mounted) {
                          showSuccessBottomSheet(
                            context,
                            fuelName: fuel.name,
                            liters: val,
                            total: total,
                            onNavigate: () => context.read<AppProvider>().setStep(AppStep.home),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                    ),
                    child: const Text('Simpan Catatan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
