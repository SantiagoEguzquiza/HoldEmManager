import 'dart:async';
import 'dart:convert';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/result.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Uri baseUrl = ApiHandler.baseUrl;

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

    final response = await http.get(
      Uri.parse('$baseUrl/FavoritoApp/$userId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> favoritos = jsonDecode(response.body);
      return favoritos.map<int>((favorito) => favorito['id'] as int).toList();
    } else {
      throw Exception('Error al cargar favoritos');
    }
  }

  Future<List<dynamic>> obtenerNotificacionesTorneo(int idJugador) async {
    final response = await http.get(
      Uri.parse('$baseUrl/NotificacionTorneoApp/jugador/$idJugador'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar notificaciones');
    }
  }

  Future<List<dynamic>> obtenerNotificacionesNoticias(int idJugador) async {
    final response = await http.get(
      Uri.parse('$baseUrl/NotificacionNoticiaApp/jugador/$idJugador'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar notificaciones');
    }
  }

  Future<List<dynamic>> obtenerTodasLasNotificaciones(int idJugador) async {
    try {
      final notificacionesTorneos =
          await obtenerNotificacionesTorneo(idJugador);

      final notificacionesNoticias =
          await obtenerNotificacionesNoticias(idJugador);

      return [...notificacionesTorneos, ...notificacionesNoticias];
    } catch (e) {
      throw Exception('Error al cargar notificaciones: $e');
    }
  }

   Future<void> toggleNotificacionesNoticias(int idJugador) async {
    final response = await http.post(
      Uri.parse('$baseUrl/JugadorApp/activar-desactivar-noticias/$idJugador'),
    );

    if (response.statusCode != 204) {
      throw Exception('Error al cambiar la configuración de notificaciones');
    }
  }

  Future<bool> obtenerEstadoNotificacionesNoticias(int idJugador) async {
    final response = await http.get(
      Uri.parse('$baseUrl/NotificacionNoticiaApp/noticiasActivadas/$idJugador'),
    );

    if (response.statusCode == 200) {
      return response.body == 'true';
    } else {
      throw Exception('Error al obtener el estado de las notificaciones');
    }
  }
}
