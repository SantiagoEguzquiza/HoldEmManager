// ignore_for_file: non_constant_identifier_names

import 'package:holdemmanager_app/Models/NotificacionTorneo/NotificacionTorneoEnum.dart';

class NotificacionesTorneo {
  int Id;
  int TorneoId;
  int JugadorId;
  NotificacionTorneoEnum TipoEvento;
  DateTime Fecha;
  String Mensaje;

  NotificacionesTorneo(
      {required this.Id,
      required this.TorneoId,
      required this.JugadorId,
      required this.TipoEvento,
      required this.Fecha,
      required this.Mensaje});

  factory NotificacionesTorneo.fromJson(Map<String, dynamic> json) {
    return NotificacionesTorneo(
      Id: json['id'],
      TorneoId: json['torneoId'],
      JugadorId: json['jugadorId'],
      TipoEvento: json['tipoEvento'],
      Fecha: DateTime.parse(json['fecha']),
      Mensaje: json['mensaje'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'torneoId': TorneoId,
      'jugadorId': JugadorId,
      'tipoEvento': TipoEvento,
      'fecha': Fecha.toIso8601String(),
      'mensaje': Mensaje
    };
  }
}
