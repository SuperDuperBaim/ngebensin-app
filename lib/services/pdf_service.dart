import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/models.dart';

class PdfService {
  static Future<void> generateAndExportPdf({
    required String username,
    required String vehicle,
    required List<LogEntry> logs,
    Map<String, String>? vehicleMap,
  }) async {
    final pdf = pw.Document();

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final totalSpent = logs.fold(0.0, (sum, e) => sum + e.total);
    final totalLiters = logs.fold(0.0, (sum, e) => sum + e.liters);
    final exportDate = DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now());

    final primaryColor = PdfColor.fromHex('#1A2E0D');
    final secondaryColor = PdfColor.fromHex('#4A6335');
    final surfaceColor = PdfColor.fromHex('#F5F2EB');
    final lightBg = PdfColor.fromHex('#FAFAFA');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'LAPORAN PENGELUARAN BBM',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Aplikasi Ngebensin · Catatan Pengisian Bahan Bakar',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Pemilik: ${username.isEmpty ? 'Pengguna' : username}',
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      pw.Text(
                        'Kendaraan: ${vehicle.toUpperCase()}',
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                      ),
                      pw.Text(
                        'Tanggal Cetak: $exportDate',
                        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(color: primaryColor, thickness: 2),
              pw.SizedBox(height: 10),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey300, thickness: 0.5),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Dokumen ini dibuat secara otomatis oleh Ngebensin App (Offline Fuel Tracker)',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                  pw.Text(
                    'Halaman ${context.pageNumber} dari ${context.pagesCount}',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ],
              ),
            ],
          );
        },
        build: (pw.Context context) => [
          // KPI Summary Cards
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: surfaceColor,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildKpiItem('Total Pengeluaran', currencyFormat.format(totalSpent), primaryColor),
                _buildKpiItem('Total Konsumsi', '${totalLiters.toStringAsFixed(2)} Liter', secondaryColor),
                _buildKpiItem('Jumlah Pengisian', '${logs.length} kali', primaryColor),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Table Section
          pw.Text(
            'Detail Riwayat Pengisian',
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: primaryColor,
            ),
          ),
          pw.SizedBox(height: 8),

          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
              fontSize: 10,
            ),
            headerDecoration: pw.BoxDecoration(color: primaryColor),
            cellHeight: 25,
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.centerRight, // Used when no vehicle column
              5: pw.Alignment.centerRight, // Used when no vehicle column
              6: pw.Alignment.centerRight, // Used when vehicle column exists
            },
            cellStyle: const pw.TextStyle(fontSize: 9),
            rowDecoration: pw.BoxDecoration(color: lightBg),
            oddRowDecoration: pw.BoxDecoration(color: surfaceColor),
            headers: <String>[
              'No', 
              'Tanggal', 
              if (vehicle == 'Semua Kendaraan') 'Kendaraan',
              'SPBU', 
              'Bensin', 
              'Jumlah (Liter)', 
              'Total (Rp)'
            ],
            data: List<List<String>>.generate(
              logs.length,
              (index) {
                final entry = logs[index];
                DateTime? parsed;
                try {
                  parsed = DateTime.parse(entry.date);
                } catch (_) {}
                final dateStr = parsed != null ? DateFormat('dd/MM/yyyy').format(parsed) : entry.date;

                return [
                  '${index + 1}',
                  dateStr,
                  if (vehicle == 'Semua Kendaraan') vehicleMap?[entry.vehicleId] ?? entry.vehicleId,
                  entry.station,
                  entry.fuel,
                  '${entry.liters.toStringAsFixed(2)} L',
                  currencyFormat.format(entry.total),
                ];
              },
            ),
          ),

          pw.SizedBox(height: 12),

          // Total Summary Row
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: pw.BoxDecoration(
              color: primaryColor,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'TOTAL KESELURUHAN',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                pw.Text(
                  '${totalLiters.toStringAsFixed(2)} L  ·  ${currencyFormat.format(totalSpent)}',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Save/Print/Share PDF using Printing package
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_BBM_Ngebensin_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  static pw.Widget _buildKpiItem(String title, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(
          title.toUpperCase(),
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
