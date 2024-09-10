import 'dart:convert';

import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/pagedResult.dart';
import 'package:http/http.dart' as http;

class Torneos {
  int id;
  String numeroRef;
  String inicio;
  String cierre;
  String nombre;
  String stack;
  String niveles;
  DateTime fecha;
  String entrada;

  Torneos({
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

  factory Torneos.fromJson(Map<String, dynamic> json) {
    return Torneos(
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

  static Future<PagedResult<Torneos>> obtenerTorneos({
    required int page,
    required int pageSize,
    required String filtro,
  }) async {
    var baseUrl = ApiHandler.baseUrl;
    var filtroFecha = '';

    try {
      var response = await http
          .get(Uri.parse(
              '$baseUrl/TorneosWeb/?page=$page&pageSize=$pageSize&filtro=$filtro&filtroFecha=$filtroFecha'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PagedResult.fromJson(
          jsonResponse,
          (data) => Torneos.fromJson(data),
        );
      } else {
        throw Exception('noData');
      }
    } catch (e) {
      throw Exception('Error al cargar torneos: $e');
    }
  }
}
