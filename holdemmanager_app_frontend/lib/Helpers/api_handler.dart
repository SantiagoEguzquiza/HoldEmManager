import 'dart:convert';
import 'package:holdemmanager_app/Helpers/result.dart';
import '../Models/Usuario.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  static final baseUrl = Uri.parse('http://10.0.2.2:5183');

  static Future<Result> login(Usuario usuario) async {
    var urlApi = ('/Login');
    var apiUrl = baseUrl.resolve(urlApi);

    var response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usuario.toJson()),
    );

    Result result = new Result(valid: false, message: response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      result.valid = true;
      return result;
    } else {
      return result;
    }
  }

  static Future<Result> register(Usuario usuario) async {
    var urlApi = ('/Usuario');
    var apiUrl = baseUrl.resolve(urlApi);

    var response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usuario.toJson()),
    );

    Result result = new Result(valid: false, message: response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      result.valid = true;
      return result;
    } else {
      return result;
    }
  }
}
