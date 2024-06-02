import 'dart:convert';
import '../Models/Usuario.dart';

class ApiHandler {
  var baseUrl = Uri.parse('http://10.0.2.2:5183');

  Future<Usuario> getUsuario() async {
    var urlApi = ('/Usuario');
    var apiUrl = baseUrl.resolve(urlApi);

    var response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Usuario.fromJson(jsonResponse);
    } else {
      throw Exception('Error al cargar el Usuario');
    }
  }
}
