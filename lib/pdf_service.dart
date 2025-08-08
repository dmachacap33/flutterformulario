import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'models.dart';
import 'package:flutter/services.dart' show rootBundle;

class PdfService {
  static Future<Uint8List> buildPdf(Fs033Form form) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final bgBytes = await rootBundle.load('assets/images/template_bg.png');
    final bgImage = pw.MemoryImage(bgBytes.buffer.asUint8List());

    final textStyle = pw.TextStyle(fontSize: 8);

    pw.Widget cell(String text, {pw.TextAlign align = pw.TextAlign.left}) =>
        pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Text(text, style: textStyle, textAlign: align));

    // Build a grid matching the template columns
    List<List<String>> rows = form.rows.map((r) {
      return [
        '', // idx se dibuja aparte si quieres
        r.tipo,
        r.ubicacion,
        ...r.q,
        r.observaciones,
      ];
    }).toList();

    // Ensure 20 rows
    while(rows.length < 20){ rows.add(['','','','','','','','','','','','']); }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const pw.EdgeInsets.all(18),
        build: (context) {
          return pw.Stack(children: [
            // Fondo corporativo
            pw.Positioned.fill(child: pw.Image(bgImage, fit: pw.BoxFit.fill)),
            // Contenido
            pw.Column(children: [
              pw.SizedBox(height: 95), // baja hasta zona de meta (ajuste fino según tu plantilla)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 56),
                child: pw.Row(
                  children: [
                    pw.Expanded(child: cell('Estación/Campamento/Sitio: ${form.estacion}')),
                    pw.SizedBox(width: 6),
                    pw.Expanded(child: cell('Inspector: ${form.inspector}')),
                    pw.SizedBox(width: 6),
                    pw.Expanded(child: cell('Fecha: ${form.fecha != null ? DateFormat('yyyy-MM-dd').format(form.fecha!) : ''}')),
                  ],
                ),
              ),
              pw.SizedBox(height: 40),
              // Tabla
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 42),
                child: pw.Table(
                  border: pw.TableBorder.all(width: 0), // sin bordes: los tiene el fondo
                  columnWidths: {
                    0: const pw.FlexColumnWidth(0.7),
                    1: const pw.FlexColumnWidth(2.2),
                    2: const pw.FlexColumnWidth(1.6),
                    3: const pw.FlexColumnWidth(0.9),
                    4: const pw.FlexColumnWidth(0.9),
                    5: const pw.FlexColumnWidth(0.9),
                    6: const pw.FlexColumnWidth(0.9),
                    7: const pw.FlexColumnWidth(0.9),
                    8: const pw.FlexColumnWidth(0.9),
                    9: const pw.FlexColumnWidth(0.9),
                    10: const pw.FlexColumnWidth(0.9),
                    11: const pw.FlexColumnWidth(0.9),
                    12: const pw.FlexColumnWidth(2.5),
                  },
                  children: List.generate(20, (i){
                    final r = form.rows.length > i ? form.rows[i] : Fs033Row();
                    return pw.TableRow(
                      children: [
                        cell('${i+1}', align: pw.TextAlign.center),
                        cell(r.tipo),
                        cell(r.ubicacion),
                        ...List.generate(9, (k) => cell(r.q.length>k ? (r.q[k]) : '')),
                        cell(r.observaciones),
                      ]
                    );
                  }),
                ),
              ),
              pw.Spacer(),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 56),
                child: cell('Firma V°B° Inspector: ${form.firma}'),
              ),
            ]),
          ]);
        },
      ),
    );

    return pdf.save();
  }
}
