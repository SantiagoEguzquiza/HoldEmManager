import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Models/Torneos.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TorneosPage extends StatefulWidget {
  const TorneosPage({super.key});

  @override
  _TorneosPage createState() => _TorneosPage();
}

class _TorneosPage extends State<TorneosPage> implements LanguageHelper {
  ApiService apiService = ApiService();
  Future<List<Torneos>>? torneos;
  Map<String, List<Torneos>> torneosPorDia = {};
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('es', 'ES');
  final TextEditingController _searchController = TextEditingController();
  Set<int> _favoritos = <int>{};
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
    cargarLocaleYTranslations();
    translationService.addListener(this);

    _cargarFavoritos().then((_) {
      _cargarTorneos('');
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !_isLoading && _hasMoreData) {
        _cargarTorneos('');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      try {
        List<int> favoritosIds = await apiService.obtenerFavoritosJugador(userId);
        setState(() {
          _favoritos = favoritosIds.toSet();
        });
      } catch (e) {
        print("Error al cargar favoritos: $e");
      }
    }
  }

  Future<void> _toggleFavorito(int torneoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      try {
        if (_favoritos.contains(torneoId)) {
          await ApiService.eliminarFavorito(userId, torneoId, context);
          setState(() {
            _favoritos.remove(torneoId);
          });
        } else {
          await ApiService.agregarFavorito(userId, torneoId, context);
          setState(() {
            _favoritos.add(torneoId);
          });
        }
      } catch (e) {
        print("Error al modificar favorito: $e");
      }
    }
  }

  void _cargarTorneos(String filtro) {
    setState(() {
      _isLoading = true;

      double currentScrollPosition = _scrollController.hasClients ? _scrollController.position.pixels : 0.0;

      torneos = Torneos.obtenerTorneos(
        page: _currentPage,
        pageSize: _pageSize,
        filtro: filtro,
      ).then((pagedResult) {
        setState(() {
          if (_currentPage == 1) {
            torneosPorDia.clear();
          }

          for (var torneo in pagedResult.items) {
            String dia = DateFormat('d MMMM yyyy', 'es_ES').format(torneo.fecha);
            if (!torneosPorDia.containsKey(dia)) {
              torneosPorDia[dia] = [];
            }
            torneosPorDia[dia]!.add(torneo);
          }

          if (pagedResult.items.length == _pageSize) {
            _currentPage++;
          } else {
            _hasMoreData = false;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(currentScrollPosition);
            }
          });
        });

        return pagedResult.items;
      }).catchError((e) {
        print("Error al cargar torneos: $e");
        setState(() {
          _hasMoreData = false;
        });
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    translationService.removeListener(this);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void actualizarLenguaje(Locale locale) {
    cargarLocaleYTranslations();
  }

  Future<void> cargarLocaleYTranslations() async {
    final Locale? locale = await translationService.getLocale();
    final Map<String, dynamic> translations = await translationService.getTranslations();

    setState(() {
      finalTranslations = translations;
      finalLocale = locale ?? const Locale('es', 'ES');
    });
  }

  String traducir(String key) {
    return finalTranslations[finalLocale.toString()]?[key] ?? key;
  }

  String formatearFecha(DateTime fecha) {
    return DateFormat('dd/MM/yyyy').format(fecha);
  }

  void _onSearchPressed() {
    final filtro = _searchController.text;
    _currentPage = 1;
    _hasMoreData = true;
    _cargarTorneos(filtro);
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
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: traducir('searchTournament'),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _onSearchPressed,
                  child: const Icon(
                    Icons.search,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Torneos>>(
              future: torneos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
                } else if (snapshot.hasError) {
                  return Center(child: Text(traducir("noData")));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(traducir("noData")));
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: torneosPorDia.keys.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < torneosPorDia.keys.length) {
                        String dia = torneosPorDia.keys.elementAt(index);
                        List<Torneos> torneosDelDia = torneosPorDia[dia]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: Text(
                                  dia.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: torneosDelDia.map((torneo) {
                                final isFavorite = _favoritos.contains(torneo.id);

                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              torneo.nombre,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                                color: isFavorite ? Colors.orangeAccent : Colors.grey,
                                              ),
                                              onPressed: () {
                                                _toggleFavorito(torneo.id);
                                              },
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today, color: Colors.orangeAccent),
                                            const SizedBox(width: 8),
                                            Text('${traducir('start')}: ${torneo.inicio}'),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.event, color: Colors.orangeAccent),
                                            const SizedBox(width: 8),
                                            Text('${traducir('end')}: ${torneo.cierre}'),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.layers, color: Colors.orangeAccent),
                                            const SizedBox(width: 8),
                                            Text('${traducir('stack')}: ${torneo.stack}'),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.timeline, color: Colors.orangeAccent),
                                            const SizedBox(width: 8),
                                            Text('${traducir('levels')}: ${torneo.niveles}'),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.attach_money, color: Colors.orangeAccent),
                                            const SizedBox(width: 8),
                                            Text('${traducir('ticket')}: ${torneo.entrada}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      } else if (_isLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.orangeAccent,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
