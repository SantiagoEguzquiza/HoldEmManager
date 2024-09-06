import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Models/Ranking.dart';

class DetalleRankingScreen extends StatelessWidget {
  final Ranking ranking;

  const DetalleRankingScreen({super.key, required this.ranking});

  String getRankingEnumText(RankingEnum rankingEnum) {
    switch (rankingEnum) {
      case RankingEnum.POKER:
        return 'Poker';
      case RankingEnum.FULLHOUSE:
        return 'Fullhouse';
      case RankingEnum.ESCALERAREAL:
        return 'Escalera Real';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.4),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 231, 229, 229),
        ),       
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ranking.playerName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Ranking: ${getRankingEnumText(ranking.rankingEnum)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Puntuación: ${ranking.puntuacion}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Número de Jugador: ${ranking.playerNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
