import 'dart:async';
import 'dart:convert';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:http/http.dart' as http;

enum RankingEnum {
  POKER,
  FULLHOUSE,
  ESCALERAREAL,
}

class Ranking {
  int id;
  int playerNumber;
  String playerName;
  int puntuacion;
  RankingEnum rankingEnum;

  Ranking({
    required this.id,
    required this.playerNumber,
    required this.playerName,
    required this.puntuacion,
    required this.rankingEnum,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      id: json['id'],
      playerNumber: json['playerNumber'],
      playerName: json['playerName'],
      puntuacion: json['puntuacion'],
      rankingEnum: RankingEnum.values[json['rankingEnum']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerNumber': playerNumber,
      'playerName': playerName,
      'puntuacion': puntuacion,
      'rankingEnum': rankingEnum.index,
    };
  }

  static Future<List<dynamic>> obtenerRankings() async {
    const String baseUrl = 'http://10.0.2.2:5183';
    final response = await http
        .get(Uri.parse('$baseUrl/RankingWeb'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar torneos');
    }
  }
}
