import 'dart:async';
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Models/Ranking.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Screens/rankings/detalle_ranking_screen.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingPage> {
  final List<Ranking> _rankings = [];
  List<Ranking> _filteredRankings = [];
  RankingEnum? _selectedRankingEnum =
      RankingEnum.POKER; // Carga Poker por defecto
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRankings();
  }

  Future<void> _fetchRankings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<dynamic> result = await Ranking.obtenerRankings();

      setState(() {
        _rankings.addAll(result.map((item) => Ranking.fromJson(item)).toList());
        _filterRankings(_selectedRankingEnum); // Filtra por defecto con Poker
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar rankings: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterRankings(RankingEnum? selectedEnum) {
    setState(() {
      _selectedRankingEnum = selectedEnum;
      _filteredRankings = _rankings
          .where((ranking) => ranking.rankingEnum == selectedEnum)
          .toList();

      // Ordena de mayor a menor
      _filteredRankings.sort((a, b) => b.puntuacion.compareTo(a.puntuacion));
    });
  }

  Color _getButtonColor(RankingEnum enumValue) {
    return _selectedRankingEnum == enumValue ? Colors.orange : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawerScrimColor: const Color.fromARGB(0, 163, 141, 141),
      drawer: const SideBar(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoticiasScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _filterRankings(RankingEnum.POKER),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(RankingEnum.POKER),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Esquinas redondeadas
                  ),
                ),
                child: const Text(
                  'Poker',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _filterRankings(RankingEnum.FULLHOUSE),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(RankingEnum.FULLHOUSE),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Esquinas redondeadas
                  ),
                ),
                child: const Text(
                  'Full House',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _filterRankings(RankingEnum.ESCALERAREAL),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(RankingEnum.ESCALERAREAL),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Esquinas redondeadas
                  ),
                ),
                child: const Text(
                  'Escalera Real',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredRankings.length,
                    itemBuilder: (context, index) {
                      var ranking = _filteredRankings[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalleRankingScreen(ranking: ranking),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text(
                                  '${index + 1}', // Posición en el ranking
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ranking.playerName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
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
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
