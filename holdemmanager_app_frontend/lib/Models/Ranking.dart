import 'dart:async';
import 'dart:convert';
import 'package:holdemmanager_app/Helpers/pagedResult.dart';
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

  static Future<PagedResult<Ranking>> obtenerRankings({
    required int page,
    required int pageSize,
    required RankingEnum tipo,
    http.Client? client,
  }) async {
    var rank = tipo.index;
    const String baseUrl = 'http://10.0.2.2:5183';
    final httpClient = client ?? http.Client();
    try {
      final response = await httpClient
          .get(Uri.parse(
              '$baseUrl/RankingWeb?tipo=$rank&page=$page&pageSize=$pageSize'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return PagedResult.fromJson(data, (json) => Ranking.fromJson(json));
      } else {
        throw Exception('serverError');
      }
    } catch (e) {
      throw Exception('serverError');
    }
  }
}
