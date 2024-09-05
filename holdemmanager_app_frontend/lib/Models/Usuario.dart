import 'dart:convert';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Models/Feedback/Feedback.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Usuario {
  int? id;
  int numberPlayer;
  String? name;
  String? email;
  String password;
  String? imageUrl;

  Usuario({
    this.id,
    required this.numberPlayer,
    this.name,
    this.email,
    required this.password,
    this.imageUrl,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      numberPlayer: json['numberPlayer'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numberPlayer': numberPlayer,
      'name': name,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
    };
  }

  static Future<Usuario> getUsuarioPorNumeroJugador(int numeroJugador) async {
    final String apiUrl =
        '${ApiHandler.baseUrl}/JugadorApp/number/$numeroJugador';
    Usuario usuario = Usuario(numberPlayer: -1, password: '');

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('jwt_token') ?? '';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Map<String, dynamic> usuarioJson = jsonDecode(response.body);
        Usuario usuario = Usuario.fromJson(usuarioJson);
        if (usuario.imageUrl != null) {
          usuario.imageUrl = Uri.decodeComponent(usuario.imageUrl!);
        }
        return usuario;
      }
      return usuario;
    } catch (e) {
      return usuario;
    }
  }

  static Future<List<FeedbackModel>?> getFeedbacksPorUserId(int userId) async {
    final String apiUrl = '${ApiHandler.baseUrl}/JugadorApp/Feedbacks/$userId';
    List<FeedbackModel> feedbacks = [];

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('jwt_token') ?? '';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> feedbacksJson = jsonDecode(response.body);
        feedbacks =
            feedbacksJson.map((json) => FeedbackModel.fromJson(json)).toList();
        return feedbacks;
      } else if (response.statusCode == 401) {
        throw Exception('sesionEx');
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<bool> setImageUrl(String? imageUrl, int numeroJugador) async {
    String? imageUrlEnCode;
    if (imageUrl != null) {
      imageUrlEnCode = Uri.encodeComponent(imageUrl);
    }
    final String apiUrl =
        "${ApiHandler.baseUrl}/JugadorApp/$imageUrlEnCode/$numeroJugador";

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('jwt_token') ?? '';

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
