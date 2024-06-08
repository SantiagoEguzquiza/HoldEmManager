import 'dart:convert';
import 'package:http/http.dart' as http;

class Usuario {
  int? id;
  String? name;
  String email;
  String password;

  Usuario({
    this.id,
    this.name,
    required this.email,
    required this.password,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  static Future<Usuario> getUsuarioPorEmail(String email) async {
    final String apiUrl = 'http://10.0.2.2:5183/Usuario/$email';
    Usuario usuario = Usuario(email: '', password: '');

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> usuarioJson = jsonDecode(response.body);
        Usuario usuario = Usuario.fromJson(usuarioJson);
        return usuario;
      }
      return usuario;

    } catch (e) {

      print(e);

      return usuario;
    }
  }
}
