import 'dart:async';
import 'dart:convert';

import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/pagedResult.dart';
import 'package:http/http.dart' as http;

class RecursosEducativos {
  int id;
  String titulo;
  String mensaje;
  String? urlImagen;
  String? urlVideo;

  RecursosEducativos({
    required this.id,
    required this.titulo,
    required this.mensaje,
    this.urlImagen,
    this.urlVideo,
  });

  factory RecursosEducativos.fromJson(Map<String, dynamic> json) {
    return RecursosEducativos(
      id: json['id'],
      titulo: json['titulo'],
      mensaje: json['mensaje'],
      urlImagen: json['urlImagen'],
      urlVideo: json['urlVideo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'mensaje': mensaje,
      'urlImagen': urlImagen,
      'urlVideo': urlVideo,
    };
  }

  static Future<PagedResult<RecursosEducativos>> obtenerRecursosEducativos({
    required int page,
    required int pageSize,
  }) async {
    var baseUrl = ApiHandler.baseUrl;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/RecursosEducativosWeb?page=$page&pageSize=$pageSize'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PagedResult.fromJson(
          jsonResponse,
          (data) => RecursosEducativos.fromJson(data),
        );
      } else {
        throw Exception('noData');
      }
    } catch (e) {
      throw Exception('serverError');
    }
  }
}
