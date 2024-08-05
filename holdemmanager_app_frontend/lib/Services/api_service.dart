import 'dart:async';
import 'dart:convert';
import 'package:holdemmanager_app/Models/FeedbackEnum.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5183';

  Future<void> enviarFeedback(
      String mensaje, int idUsuario, DateTime fecha) async {
  Future<List<dynamic>> obtenerRecursosEducativos() async {
    final response = await http
        .get(Uri.parse('$baseUrl/RecursosEducativosWeb'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar recursos educativos');
    }
  }



  Future<void> enviarFeedback(String mensaje, int idUsuario, DateTime fecha,
      bool isAnonimo, FeedbackEnum categoria) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/FeedbackApp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'idUsuario': idUsuario,
          'fecha': fecha.toIso8601String(),
          'mensaje': mensaje,
          'categoria': categoria.index,
          'isAnonimo': isAnonimo,
        }),
      );

      if (response.statusCode != 200) {
        final errorResponse = jsonDecode(response.body);
        throw Exception(
            'Error al enviar feedback: ${errorResponse['message']}');
      }
    } catch (e) {
      print('Error al enviar feedback: $e');
    }
  }

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
