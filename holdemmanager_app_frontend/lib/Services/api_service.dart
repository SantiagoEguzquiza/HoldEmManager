import 'dart:async';
import 'dart:convert';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/result.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5183';

  Future<List<dynamic>> obtenerTorneos(String filtro) async {
    final http.Response response;

    if (filtro.isEmpty || filtro == "") {
      response = await http
          .get(Uri.parse('$baseUrl/TorneosWeb/listadoCompleto'))
          .timeout(const Duration(seconds: 10));
    } else {
      response = await http
          .get(Uri.parse('$baseUrl/TorneosWeb/filtered/$filtro'))
          .timeout(const Duration(seconds: 10));
    }

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar torneos');
    }
  }

  static Future<Result> agregarFavorito(
      int? jugadorId, int torneoId, context) async {
    try {
      var baseUrl = ApiHandler.baseUrl;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('jwt_token') ?? '';
      final int? userId = prefs.getInt('userId');
      bool valid = await ApiHandler.checkTokenAndFetchData(context);

      if (valid) {
        final response = await http.post(
          Uri.parse('$baseUrl/FavoritoApp/$userId/$torneoId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'jugadorId': jugadorId,
            'torneoId': torneoId,
          }),
        );

        if (response.statusCode != 200) {
          return Result(valid: false, message: 'favoritoError');
        }
        return Result(valid: true, message: '');
      } else {
        return Result(valid: false, message: 'sesionEx');
      }
    } catch (e) {
      return Result(valid: false, message: 'serverError');
    }
  }

  static Future<Result> eliminarFavorito(
      int? jugadorId, int torneoId, context) async {
    try {
      var baseUrl = ApiHandler.baseUrl;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('jwt_token') ?? '';
      final int? userId = prefs.getInt('userId');
      bool valid = await ApiHandler.checkTokenAndFetchData(context);

      if (valid) {
        final response = await http.delete(
          Uri.parse('$baseUrl/FavoritoApp/$userId/$torneoId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'jugadorId': jugadorId,
            'torneoId': torneoId,
          }),
        );

        if (response.statusCode != 200) {
          return Result(valid: false, message: 'favoritoError');
        }
        return Result(valid: true, message: '');
      } else {
        return Result(valid: false, message: 'sesionEx');
      }
    } catch (e) {
      return Result(valid: false, message: 'serverError');
    }
  }

  Future<List<int>> obtenerFavoritosJugador(int? userId) async {
    var baseUrl = ApiHandler.baseUrl;

    final response = await http.get(Uri.parse('$baseUrl/FavoritoApp/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<int>();
    } else {
      throw Exception('Error al cargar favoritos');
    }
  }
}
