import 'dart:convert';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:http/http.dart' as http;

class Usuario {
  int? id;
  int numberPlayer;
  String? name;
  String? email;
  String password;
  String? imageUrl;

  Usuario(
      {this.id,
      required this.numberPlayer,
      this.name,
      this.email,
      required this.password,
      this.imageUrl});

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
      'imageUrl': imageUrl
    };
  }

  static Future<Usuario> getUsuarioPorNumeroJugador(int numeroJugador) async {
    final String apiUrl = '${ApiHandler.baseUrl}/JugadorApp/$numeroJugador';
    Usuario usuario = Usuario(numberPlayer: -1, password: '');

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> usuarioJson = jsonDecode(response.body);
        Usuario usuario = Usuario.fromJson(usuarioJson);
        if (!(usuario.imageUrl == null)) {
          usuario.imageUrl = Uri.decodeComponent(usuario.imageUrl!);
        }
        return usuario;
      }
      return usuario;
    } catch (e) {
      print(e);

      return usuario;
    }
  }

  static Future<bool> setImageUrl(String? imageUrl, int numeroJugador) async {
    String? imageUrlEnCode = null;
    if (imageUrl != null) {
      imageUrlEnCode = Uri.encodeComponent(imageUrl!);
    }
    final String apiUrl =
        "${ApiHandler.baseUrl}/JugadorApp/$imageUrlEnCode/$numeroJugador";

    try {
      final response = await http.put(Uri.parse(apiUrl));
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
