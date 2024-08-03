import 'dart:convert';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/pagedResult.dart';
import 'package:http/http.dart' as http;

class Contacto {
  int? id;
  String infoCasino;
  String direccion;
  String numeroTelefono;
  String email;

  Contacto({
    this.id,
    required this.infoCasino,
    required this.direccion,
    required this.numeroTelefono,
    required this.email,
  });

  factory Contacto.fromJson(Map<String, dynamic> json) {
    return Contacto(
      id: json['id'],
      infoCasino: json['infoCasino'],
      direccion: json['direccion'],
      numeroTelefono: json['numeroTelefono'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'infoCasino': infoCasino,
      'direccion': direccion,
      'numeroTelefono': numeroTelefono,
      'email': email,
    };
  }

  static Future<PagedResult<Contacto>> obtenerContactos({
    required int page,
    required int pageSize,
  }) async {
    var baseUrl = ApiHandler.baseUrl;
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/ContactoWeb?page=$page&pageSize=$pageSize'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PagedResult.fromJson(
          jsonResponse,
          (data) => Contacto.fromJson(data),
        );
      } else {
        throw Exception('noData');
      }
    } catch (e) {
      throw Exception('serverError');
    }
  }
}
