import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    var formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now()); // Assuming you want to display the current date

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.4),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 231, 229, 229),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ranking.playerName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ranking: ${getRankingEnumText(ranking.rankingEnum)}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
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
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Número de Jugador: ${ranking.playerNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Fecha: $formattedDate',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
