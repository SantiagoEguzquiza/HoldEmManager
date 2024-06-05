import 'dart:convert';
import '../Models/Usuario.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  static final baseUrl = Uri.parse('http://10.0.2.2:5183');

  static Future<bool> login(Usuario usuario) async {
    var urlApi = ('/Login');
    var apiUrl = baseUrl.resolve(urlApi);

    var response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
