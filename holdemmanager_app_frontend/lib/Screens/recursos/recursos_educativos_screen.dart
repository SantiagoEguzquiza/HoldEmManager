import 'dart:async';
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/pagedResult.dart';
import 'package:holdemmanager_app/Models/Recurso.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
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
  String? _errorMessage;
  bool isDialogVisible =
      false;

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    _fetchRecursos();
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

  void mostrarDialogoError(String mensaje) {
  if (!isDialogVisible) {
    isDialogVisible = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(finalTranslations[finalLocale.toString()]?['error'] ?? 'Error'),
          content: Text(traducirError(mensaje)),
          actions: <Widget>[
            TextButton(
              child: Text(
                finalTranslations[finalLocale.toString()]?['ok'] ?? 'OK',
                style: const TextStyle(color: Colors.orangeAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                isDialogVisible = false;
              },
            ),
          ],
        );
      },
    );
  }
}

  String traducirError(String errorKey) {
    return finalTranslations[finalLocale.toString()]?[errorKey] ??
        'Error en el servidor, inténtelo de nuevo más tarde';
  }

  Future<void> _fetchRecursos() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await RecursosEducativos.obtenerRecursosEducativos(
          page: _currentPage, pageSize: _pageSize, filtro: "NO");
      setState(() {
        _recursos.addAll(result.items);
        _currentPage++;
        _hasMoreData = result.hasNextPage;
      });
    } catch (e) {
      String errorKey = 'serverError';
      if (e.toString().contains('serverError')) {
        errorKey = 'serverError';
      }
      setState(() {
        _errorMessage = errorKey;
      });
      mostrarDialogoError(errorKey);
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
          Expanded(
            child: _recursos.isEmpty && !_isLoading
                ? Center(
                    child: Text(
                      _errorMessage != null
                          ? traducirError(_errorMessage!)
                          : finalTranslations[finalLocale.toString()]
                                  ?['noData'] ??
                              'No hay datos disponibles',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _recursos.length + (_isLoading ? 2 : 1),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            finalTranslations[finalLocale.toString()]
                                    ?['educationalResources'] ??
                                'Educational Resources',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else if (index == _recursos.length + 1) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.orangeAccent,
                            ),
                          ),
                        );
                      }
                      var recurso = _recursos[index - 1];
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
                  ),
          ),
        ],
      ),
    );
  }
}
