import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //final String baseUrl = 'http://localhost:5183';
  final String baseUrl = 'http://10.0.2.2:5183';

  Future<List<dynamic>> obtenerRecursosEducativos() async {
    final response =
        await http.get(Uri.parse('$baseUrl/RecursosEducativosWeb'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar recursos educativos');
    }
  }

  Future<List<dynamic>> obtenerContactos() async {
    final response = await http.get(Uri.parse('$baseUrl/ContactoWeb'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar contactos');
    }
  }

  Future<List<dynamic>> obtenerNoticias() async {
    final response = await http.get(Uri.parse('$baseUrl/NoticiasWeb'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar noticias');
    }
  }
}
