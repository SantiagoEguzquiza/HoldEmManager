import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5183';

  Future<List<dynamic>> obtenerTorneos() async {
    final response = await http
        .get(Uri.parse('$baseUrl/TorneosWeb/listadoCompleto'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar torneos');
    }
  }
}
