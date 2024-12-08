
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFGenerator {
  Future<void> generateAndSharePDF(List<Map<String, dynamic>> results) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: results.map((result) {
              return pw.Text(
                '${result['name']}: ${result['status']}',
                style: pw.TextStyle(fontSize: 14),
              );
            }).toList(),
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'scan_results.pdf');
  }
}
