// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
//import 'package:holdemmanager_app/Models/TorneoFavorito.dart';
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
  late Future<List<dynamic>> torneos = Future.value([]);
  Map<String, List<dynamic>> torneosPorDia = {};
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('es', 'ES');
  final TextEditingController _searchController = TextEditingController();
  Set<int> _favoritos = <int>{};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
    cargarLocaleYTranslations();
    translationService.addListener(this);
    _cargarFavoritos().then((_) {
      _cargarTorneos('');
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
        List<int> favoritosIds =
            await apiService.obtenerFavoritosJugador(userId);
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
      torneos = apiService.obtenerTorneos(filtro).then((data) async {
        setState(() {
          torneosPorDia.clear();
          for (var torneo in data) {
            DateTime fecha = DateTime.parse(torneo['fecha']);
            String dia = DateFormat('d ' 'MMMM' ' yyyy', 'es_ES').format(fecha);
            if (!torneosPorDia.containsKey(dia)) {
              torneosPorDia[dia] = [];
            }
            torneosPorDia[dia]!.add(torneo);
          }
        });
        return data;
      });
    });
  }

  @override
  void dispose() {
    translationService.removeListener(this);
    _searchController.dispose();
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
            child: FutureBuilder<List<dynamic>>(
              future: torneos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text("Error al cargar los torneos"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No hay torneos disponibles"));
                } else {
                  return ListView.builder(
                    itemCount: torneosPorDia.keys.length,
                    itemBuilder: (context, index) {
                      String dia = torneosPorDia.keys.elementAt(index);
                      List<dynamic> torneosDelDia = torneosPorDia[dia]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                const DataColumn(label: Text('#')),
                                DataColumn(label: Text(traducir('start'))),
                                DataColumn(label: Text(traducir('end'))),
                                DataColumn(label: Text(traducir('event'))),
                                DataColumn(label: Text(traducir('stack'))),
                                DataColumn(label: Text(traducir('levels'))),
                                DataColumn(label: Text(traducir('ticket'))),
                                DataColumn(label: Text(traducir('favorite'))),
                              ],
                              rows: torneosDelDia.map((torneo) {
                                final isFavorite =
                                    _favoritos.contains(torneo['id']);

                                return DataRow(cells: [
                                  DataCell(Text(torneo['numeroRef'])),
                                  DataCell(Text(torneo['inicio'])),
                                  DataCell(Text(torneo['cierre'])),
                                  DataCell(Text(torneo['nombre'])),
                                  DataCell(Text(torneo['stack'])),
                                  DataCell(Text(torneo['niveles'])),
                                  DataCell(Text(torneo['entrada'])),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.orangeAccent
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        _toggleFavorito(torneo['id']);
                                      },
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ],
                      );
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
