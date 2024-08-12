import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Models/Contacto.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';

class ContactoScreen extends StatefulWidget {
  const ContactoScreen({super.key});

  @override
  _ContactoScreenState createState() => _ContactoScreenState();
}

class _ContactoScreenState extends State<ContactoScreen> implements LanguageHelper {
  final ApiService apiService = ApiService();
  final List<Contacto> _contactos = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _pageSize = 10;

  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    _fetchContactos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData) {
        _fetchContactos();
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

  String traducirError(String errorKey) {
    return finalTranslations[finalLocale.toString()]?[errorKey] ??
        'Error en el servidor, inténtelo de nuevo más tarde';
  }

  Future<void> _fetchContactos() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await Contacto.obtenerContactos(
        page: _currentPage,
        pageSize: _pageSize,
      );
      setState(() {
        _contactos.addAll(result.items);
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
            child: _contactos.isEmpty && !_isLoading
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
                    itemCount: _contactos.length + (_isLoading ? 2 : 1),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            finalTranslations[finalLocale.toString()]?['contact'] ??
                                'Educational Resources',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }else if (index == _contactos.length + 1) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.orangeAccent,
                            ),
                          ),
                        );
                      }
                      var contacto = _contactos[index - 1];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            contacto.direccion,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline,
                                      color: Colors.orangeAccent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      contacto.infoCasino,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.phone,
                                      color: Colors.orangeAccent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      contacto.numeroTelefono,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.email,
                                      color: Colors.orangeAccent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      contacto.email,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
