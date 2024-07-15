import 'dart:convert';

import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:http/http.dart' as http;

class Mapa {
  int? id;
  int planoId;
  List<int>? plano;

  Mapa({this.id, required this.planoId, this.plano});

  factory Mapa.fromJson(Map<String, dynamic> json) {
    List<int> planoBytes = base64Decode(json['plano']);

    return Mapa(
      id: json['id'],
      planoId: json['planoId'],
      plano: planoBytes,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'planoId': planoId, 'plano': plano};
  }

  static Future<List<Mapa>> getMapas() async {
    final String apiUrl = '${ApiHandler.baseUrl}/MapaApp';
    List<Mapa> mapas = [];
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        mapas = jsonResponse.map((json) => Mapa.fromJson(json)).toList();
        return mapas;
      }
      return mapas;
    } catch (e) {
      print(e);

      return mapas;
    }
  }
}
