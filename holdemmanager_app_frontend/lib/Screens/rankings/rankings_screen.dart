import 'dart:async';
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/pagedResult.dart';
import 'package:holdemmanager_app/Models/Ranking.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Screens/rankings/detalle_ranking_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingPage> implements LanguageHelper {
  final List<Ranking> _rankings = [];
  List<Ranking> _filteredRankings = [];
  RankingEnum? _selectedRankingEnum = RankingEnum.POKER;
  bool _isLoading = false;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    _scrollController.addListener(_onScroll);
    _fetchRankings();
  }

  @override
  void dispose() {
    translationService.removeListener(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void actualizarLenguaje(Locale locale) {
    cargarLocaleYTranslations();
  }

  Future<void> cargarLocaleYTranslations() async {
    final Locale? locale = await translationService.getLocale();
    final Map<String, dynamic> translations =
        await translationService.getTranslations();

    setState(() {
      finalTranslations = translations;
      finalLocale = locale ?? const Locale('en', 'US');
    });
  }

  String traducirError(String errorKey) {
    return finalTranslations[finalLocale.toString()]?[errorKey] ??
        'Error en el servidor, inténtelo de nuevo más tarde';
  }

  void mostrarDialogoError(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              finalTranslations[finalLocale.toString()]?['error'] ?? 'Error'),
          content: Text(traducirError(mensaje)),
          actions: <Widget>[
            TextButton(
              child: Text(
                finalTranslations[finalLocale.toString()]?['ok'] ?? 'OK',
                style: const TextStyle(color: Colors.orangeAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchRankings() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final PagedResult<Ranking> result = await Ranking.obtenerRankings(
        page: _currentPage,
        pageSize: 10,
        tipo: _selectedRankingEnum!,
      );

      setState(() {
        _currentPage++;
        _rankings.addAll(result.items);
        _filteredRankings = _rankings
            .where((ranking) => ranking.rankingEnum == _selectedRankingEnum)
            .toList();

        _filteredRankings.sort((a, b) => b.puntuacion.compareTo(a.puntuacion));
      });
    } catch (e) {
      mostrarDialogoError('serverError');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterRankings(RankingEnum? selectedEnum) {
    setState(() {
      _selectedRankingEnum = selectedEnum;
      _currentPage = 1;
      _rankings.clear();
      _filteredRankings.clear();
      _fetchRankings();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchRankings();
    }
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Rankings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _filterRankings(RankingEnum.POKER),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(RankingEnum.POKER),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
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
                    borderRadius: BorderRadius.circular(8.0),
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
                    borderRadius: BorderRadius.circular(8.0),
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
            child: _isLoading && _filteredRankings.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child:
                          CircularProgressIndicator(color: Colors.orangeAccent),
                    ),
                  )
                : _filteredRankings.isEmpty
                    ? Center(
                        child: Text(
                          traducirError('noData'),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _filteredRankings.length + 1,
                        itemBuilder: (context, index) {
                          if (index < _filteredRankings.length) {
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
                                        '${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                          } else if (_isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: CircularProgressIndicator(
                                    color: Colors.orangeAccent),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
