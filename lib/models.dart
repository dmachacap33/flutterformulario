import 'dart:convert';

class Fs033Row {
  String tipo;
  String ubicacion;
  List<String> q; // 9 respuestas
  String observaciones;

  Fs033Row({
    this.tipo = '',
    this.ubicacion = '',
    List<String>? q,
    this.observaciones = '',
  }) : q = q ?? List.filled(9, '');

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'ubicacion': ubicacion,
        'q': q,
        'observaciones': observaciones,
      };

  factory Fs033Row.fromJson(Map<String, dynamic> json) => Fs033Row(
        tipo: json['tipo'] ?? '',
        ubicacion: json['ubicacion'] ?? '',
        q: (json['q'] as List?)?.map((e) => e.toString()).toList() ?? List.filled(9, ''),
        observaciones: json['observaciones'] ?? '',
      );
}

class Fs033Form {
  String estacion;
  String inspector;
  DateTime? fecha;
  String firma;
  List<Fs033Row> rows;

  Fs033Form({
    this.estacion = '',
    this.inspector = '',
    this.fecha,
    this.firma = '',
    List<Fs033Row>? rows,
  }) : rows = rows ?? List.generate(20, (_) => Fs033Row());

  Map<String, dynamic> toJson() => {
        'estacion': estacion,
        'inspector': inspector,
        'fecha': fecha?.toIso8601String(),
        'firma': firma,
        'rows': rows.map((r) => r.toJson()).toList(),
      };

  factory Fs033Form.fromJson(Map<String, dynamic> json) => Fs033Form(
        estacion: json['estacion'] ?? '',
        inspector: json['inspector'] ?? '',
        fecha: json['fecha'] != null ? DateTime.tryParse(json['fecha']) : null,
        firma: json['firma'] ?? '',
        rows: (json['rows'] as List?)?.map((e) => Fs033Row.fromJson(e as Map<String, dynamic>)).toList() ?? List.generate(20, (_) => Fs033Row()),
      );

  String toRawJson() => jsonEncode(toJson());
  factory Fs033Form.fromRawJson(String s) => Fs033Form.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
