import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../form_provider.dart';
import '../models.dart';
import 'package:printing/printing.dart';
import '../pdf_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<FormProvider>().data;
    final prov = context.read<FormProvider>();
    final opciones = context.watch<FormProvider>().opciones;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FS.033 – Inspección de Herramientas'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(child: TextFormField(
                        initialValue: form.estacion,
                        decoration: const InputDecoration(labelText: 'Estación / Campamento / Sitio'),
                        onChanged: (v)=> form.estacion = v,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: TextFormField(
                        initialValue: form.inspector,
                        decoration: const InputDecoration(labelText: 'Inspector'),
                        onChanged: (v)=> form.inspector = v,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: InkWell(
                        onTap: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: form.fecha ?? now,
                            firstDate: DateTime(now.year-1),
                            lastDate: DateTime(now.year+2),
                          );
                          if(picked!=null) prov.setFecha(picked);
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Fecha'),
                          child: Text(prov.fechaStr.isEmpty ? '—' : prov.fechaStr),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _RowsTable(opciones: opciones),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextFormField(
                    initialValue: form.firma,
                    decoration: const InputDecoration(labelText: 'Firma V°B° Inspector'),
                    onChanged: (v)=> form.firma = v,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonal(onPressed: prov.reset, child: const Text('Limpiar todo')),
                  FilledButton.tonal(onPressed: () async { await prov.saveLocal(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guardado local.')));}, child: const Text('Guardar local')),
                  FilledButton.tonal(onPressed: () async { final ok = await prov.loadLocal(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Cargado.' : 'No hay datos.')));}, child: const Text('Cargar local')),
                  FilledButton(onPressed: () async {
                    final bytes = await PdfService.buildPdf(prov.data);
                    await Printing.layoutPdf(onLayout: (format) async => bytes);
                  }, child: const Text('Generar / Imprimir PDF')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _RowsTable extends StatefulWidget {
  final List<String> opciones;
  const _RowsTable({required this.opciones});

  @override
  State<_RowsTable> createState() => _RowsTableState();
}

class _RowsTableState extends State<_RowsTable> {
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<FormProvider>();
    final rows = prov.data.rows;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lista de Verificación (20 filas, Q1..Q9)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                columns: const [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('Tipo / Clase')),
                  DataColumn(label: Text('Ubicación / Uso')),
                  DataColumn(label: Text('Q1')),
                  DataColumn(label: Text('Q2')),
                  DataColumn(label: Text('Q3')),
                  DataColumn(label: Text('Q4')),
                  DataColumn(label: Text('Q5')),
                  DataColumn(label: Text('Q6')),
                  DataColumn(label: Text('Q7')),
                  DataColumn(label: Text('Q8')),
                  DataColumn(label: Text('Q9')),
                  DataColumn(label: Text('Observaciones')),
                ],
                rows: List.generate(rows.length, (i){
                  final r = rows[i];
                  return DataRow(cells: [
                    DataCell(Text('${i+1}')),
                    DataCell(SizedBox(width: 160, child: TextFormField(
                      initialValue: r.tipo,
                      onChanged: (v){ r.tipo=v; },
                    ))),
                    DataCell(SizedBox(width: 150, child: TextFormField(
                      initialValue: r.ubicacion,
                      onChanged: (v){ r.ubicacion=v; },
                    ))),
                    ...List.generate(9, (k)=> DataCell(SizedBox(width: 70, child: DropdownButtonFormField<String>(
                      value: r.q[k].isEmpty ? null : r.q[k],
                      items: widget.opciones.map((e)=> DropdownMenuItem(value: e.isEmpty? '' : e, child: Text(e.isEmpty? '—' : e))).toList(),
                      onChanged: (v){ setState((){ r.q[k] = v ?? ''; }); },
                    )))),
                    DataCell(SizedBox(width: 240, child: TextFormField(
                      initialValue: r.observaciones,
                      maxLines: 2,
                      onChanged: (v){ r.observaciones=v; },
                    ))),
                  ]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
