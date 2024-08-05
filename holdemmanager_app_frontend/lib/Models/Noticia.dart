import 'dart:async';
import 'dart:convert';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/pagedResult.dart';
import 'package:http/http.dart' as http;

class Noticia {
  int id;
  String titulo;
  DateTime fecha;
  String mensaje;
  String? idImagen;

  Noticia({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.mensaje,
    this.idImagen,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'],
      titulo: json['titulo'],
      fecha: DateTime.parse(json['fecha']),
      mensaje: json['mensaje'],
      idImagen: json['idImagen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'fecha': fecha.toIso8601String(),
      'mensaje': mensaje,
      'idImagen': idImagen,
    };
  }

  static Future<PagedResult<Noticia>> obtenerNoticias(
      {required int page, required int pageSize, required String filtro}) async {
    var baseUrl = ApiHandler.baseUrl;
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/NoticiasWeb?page=$page&pageSize=$pageSize&filtro=$filtro'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PagedResult.fromJson(jsonResponse, (data) => Noticia.fromJson(data));
      } else {
        throw Exception('noData');
      }
    } catch (e) {
      throw Exception('serverError');
    }
  }
}