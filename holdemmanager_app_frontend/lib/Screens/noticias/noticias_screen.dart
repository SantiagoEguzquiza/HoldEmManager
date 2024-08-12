import 'dart:async';
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/pagedResult.dart';
import 'package:holdemmanager_app/Models/Noticia.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/noticias/detalle_noticia_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:intl/intl.dart';

class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  _NoticiasScreenState createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen>
    implements LanguageHelper {
  int _selectedIndex = 0;
  final int _pageSize = 10;
  int _currentPage = 1;
  final List<Noticia> _noticias = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMoreData = true;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    _fetchNoticias();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData) {
        _fetchNoticias();
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
              },
            ),
          ],
        );
      },
    );
  }

  String traducirError(String errorKey) {
    return finalTranslations[finalLocale.toString()]?[errorKey] ??
        'Error en el servidor, inténtelo de nuevo más tarde';
  }

  Future<void> _fetchNoticias() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final PagedResult<Noticia> result = await Noticia.obtenerNoticias(
        page: _currentPage,
        pageSize: _pageSize,
        filtro: "NO"
      );
      setState(() {
        _noticias.addAll(result.items);
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

  void _onNavBarTap(int index) {
    if (_isLoading) return;
    
    setState(() {
      _selectedIndex = index;
    });

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawerScrimColor: const Color.fromARGB(0, 163, 141, 141),
      drawer: const SideBar(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
      body: Column(
        children: [
          Expanded(
            child: _noticias.isEmpty && !_isLoading
                ? Center(
                    child: Text(
                      _errorMessage != null
                          ? traducirError(_errorMessage!)
                          : finalTranslations[finalLocale.toString()]?['noData'] ??
                              'No hay datos disponibles',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _noticias.length + (_isLoading ? 2 : 1),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            finalTranslations[finalLocale.toString()]?['newsForum'] ??
                                'News Forum',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else if (index == _noticias.length + 1) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.orangeAccent,
                            ),
                          ),
                        );
                      }

                      var noticia = _noticias[index - 1];
                      var fechaFormateada =
                          DateFormat('dd/MM/yyyy').format(noticia.fecha);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalleNoticiaScreen(noticia: noticia),
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
                                  noticia.titulo,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      fechaFormateada,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (noticia.idImagen != null &&
                                    noticia.idImagen!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      noticia.idImagen!,
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