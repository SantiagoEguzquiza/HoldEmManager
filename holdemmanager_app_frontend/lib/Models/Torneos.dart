class TorneoFavoritoModel {
  int id;
  String numeroRef;
  String inicio;
  String cierre;
  String nombre;
  String stack;
  String niveles;
  DateTime fecha;
  String entrada;

  TorneoFavoritoModel({
    required this.id,
    required this.numeroRef,
    required this.inicio,
    required this.cierre,
    required this.nombre,
    required this.stack,
    required this.niveles,
    required this.fecha,
    required this.entrada,
  });

  factory TorneoFavoritoModel.fromJson(Map<String, dynamic> json) {
    return TorneoFavoritoModel(
      id: json['id'],
      numeroRef: json['numeroRef'],
      inicio: json['inicio'],
      cierre: json['cierre'],
      nombre: json['nombre'],
      stack: json['stack'],
      niveles: json['niveles'],
      fecha: DateTime.parse(json['fecha']),
      entrada: json['entrada'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroRef': numeroRef,
      'inicio': inicio,
      'cierre': cierre,
      'nombre': nombre,
      'stack': stack,
      'niveles': niveles,
      'fecha': fecha.toIso8601String(),
      'entrada': entrada,
    };
  }
}
