import 'dart:async';
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/pagedResult.dart';
import 'package:holdemmanager_app/Models/Recurso.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/home_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Screens/recursos/detalle_recursos_educativos_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';

class RecursosEducativosScreen extends StatefulWidget {
  const RecursosEducativosScreen({super.key});

  @override
  _RecursosEducativosScreenState createState() =>
      _RecursosEducativosScreenState();
}

class _RecursosEducativosScreenState extends State<RecursosEducativosScreen>
    implements LanguageHelper {
  late Future<PagedResult<RecursosEducativos>> _futureRecursos;
  final List<RecursosEducativos> _recursos = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMoreData = true;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');
  final int _pageSize = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    _futureRecursos = _fetchRecursos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData) {
        _fetchRecursos();
      }
    });
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

  void mostrarNotificacionError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  String traducirError(String errorKey) {
    return finalTranslations[finalLocale.toString()]?[errorKey] ??
        'Error en el servidor, inténtelo de nuevo más tarde';
  }

  Future<PagedResult<RecursosEducativos>> _fetchRecursos() async {
    if (_isLoading || !_hasMoreData) return Future.error('loading');

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await RecursosEducativos.obtenerRecursosEducativos(
        page: _currentPage,
        pageSize: _pageSize,
      );
      setState(() {
        _recursos.addAll(result.items);
        _currentPage++;
        _hasMoreData = result.hasNextPage;
      });
      return result;
    } catch (e) {
      mostrarNotificacionError(traducirError(e.toString()));
      return Future.error(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              MaterialPageRoute(builder: (context) => const HomeScreen()),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            padding: const EdgeInsets.all(25.0),
            child: Text(
              finalTranslations[finalLocale.toString()]?['educationalResources'] ??
                  'Educational Resources',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<PagedResult<RecursosEducativos>>(
              future: _futureRecursos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.orangeAccent,
                  ));
                } else if (snapshot.hasError) {
                  String errorMessage;
                  if (snapshot.error is TimeoutException) {
                    errorMessage = traducirError('timeoutError');
                  } else {
                    errorMessage = traducirError('serverError');
                  }
                  return Center(child: Text(errorMessage));
                } else if (snapshot.hasData && snapshot.data!.items.isEmpty) {
                  return Center(
                    child: Text(
                      finalTranslations[finalLocale.toString()]?['noData'] ??
                          'No hay recursos disponibles',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: _recursos.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _recursos.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var recurso = _recursos[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalleRecursoScreen(recurso: recurso),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recurso.titulo,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (recurso.urlImagen != null &&
                                    recurso.urlImagen!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      recurso.urlImagen!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
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