import 'dart:convert';
import 'package:flutter/services.dart';
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

        if (mapas.length <= 1) {

          mapas = await cargarMapasDefault();
        } else if (mapas.length > 1 && mapas[0].planoId == 2) {
          
          Mapa temp = mapas[0];
          mapas[0] = mapas[1];
          mapas[1] = temp;
        }

        return mapas;
      }
      return mapas;
    } catch (e) {
      final List<Mapa> mapasDefaults = await cargarMapasDefault();
      mapas = mapasDefaults;
      return mapas;
    }
  }

  static Future<List<Mapa>> cargarMapasDefault() async {
    final ByteData asset1 =
        await rootBundle.load('lib/assets/images/default-map.jpg');
    final ByteData asset2 =
        await rootBundle.load('lib/assets/images/default-map.jpg');
    final List<int> bytes1 = asset1.buffer.asUint8List();
    final List<int> bytes2 = asset2.buffer.asUint8List();

    return [
      Mapa(id: 0, planoId: 1, plano: bytes1),
      Mapa(id: 1, planoId: 2, plano: bytes2),
    ];
  }
}
