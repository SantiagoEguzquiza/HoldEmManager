// ignore_for_file: non_constant_identifier_names

import 'package:holdemmanager_app/Models/NotificacionNoticia/NotificacionesNoticiaEnum.dart';

class NotificacionNoticia {
  int Id;
  int JugadorId;
  NotificacionNoticiaEnum TipoEvento;
  DateTime Fecha;
  String Mensaje;

  NotificacionNoticia(
      {required this.Id,
      required this.JugadorId,
      required this.TipoEvento,
      required this.Fecha,
      required this.Mensaje});

  factory NotificacionNoticia.fromJson(Map<String, dynamic> json) {
    return NotificacionNoticia(
      Id: json['id'],
      JugadorId: json['jugadorId'],
      TipoEvento: json['tipoEvento'],
      Fecha: DateTime.parse(json['fecha']),
      Mensaje: json['mensaje'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'jugadorId': JugadorId,
      'tipoEvento': TipoEvento,
      'fecha': Fecha.toIso8601String(),
      'mensaje': Mensaje
    };
  }
}
