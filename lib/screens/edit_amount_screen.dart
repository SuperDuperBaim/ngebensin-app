import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../widgets/common_widgets.dart';

class EditAmountScreen extends StatefulWidget {
  final LogEntry entry;
  const EditAmountScreen({super.key, required this.entry});

  @override
  State<EditAmountScreen> createState() => _EditAmountScreenState();
}

class _EditAmountScreenState extends State<EditAmountScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrlInit();
  }

  void _ctrlInit() {
    _controller.text = _formatNumberWithDots(widget.entry.total.toInt().toString());
  }

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
    final fuel = fuels.values.expand((list) => list).firstWhere((f) => f.name == widget.entry.fuel, orElse: () => fuels.values.first.first);
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final minPrice = fuel.price; 
    final maxPrice = fuel.price * 30; 
    
    final helperText = 'Minimal ${currencyFormat.format(minPrice)} (1L) · Maksimal ${currencyFormat.format(maxPrice)} (30L)';
    final hintFormatted = currencyFormat.format(minPrice).replaceAll('Rp ', '');

    final rawNominals = [10000, 20000, 30000, 40000, 50000, 75000, 100000];
    final quickNominals = rawNominals.where((v) => v >= minPrice && v <= maxPrice).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Nominal (Rupiah)', style: TextStyle(color: Colors.white)),
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
              Text(
                'NOMINAL (RUPIAH)',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                onChanged: (val) {
                  if (val.isNotEmpty) {
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
                  suffixText: '',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                helperText,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDark.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'OPSI NOMINAL CEPAT',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickNominals.map((nom) {
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
                }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
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
                    final updated = LogEntry(
                      id: widget.entry.id,
                      fuel: widget.entry.fuel,
                      station: widget.entry.station,
                      liters: liters,
                      total: val,
                      date: widget.entry.date,
                      vehicleId: widget.entry.vehicleId,
                    );

                    context.read<AppProvider>().updateLog(updated);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                  ),
                  child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
