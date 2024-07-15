import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Models/Mapa.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> implements LanguageHelper {
  int _selectedIndex = 0;
  Uint8List imageBytes1 = Uint8List(0);
  Uint8List imageBytes2 = Uint8List(0);
  bool _isLoading = true;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    cargarMapas();
  }

  void cargarMapas() async {
    try {
      List<Mapa> mapas = await Mapa.getMapas();
      if (mapas.isNotEmpty && mapas.length >= 2) {
        List<int>? listaInt1 = mapas[0].plano;
        List<int>? listaInt2 = mapas[1].plano;
        if (listaInt1 != null && listaInt2 != null) {
          setState(() {
            imageBytes1 = Uint8List.fromList(listaInt1);
            imageBytes2 = Uint8List.fromList(listaInt2);
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        print('No se encontraron suficientes mapas disponibles');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error al cargar mapas: $e');
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
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      finalTranslations[finalLocale.toString()]?['fullPlane'] ??
                          '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 4.0,
                        constrained: true,
                        panEnabled: true,
                        child: Container(
                          alignment: Alignment.center,
                          child: Transform.rotate(
                            angle: -90 * (3.141592653589793 / 180),
                            alignment: Alignment.center,
                            child: Image.memory(
                              imageBytes1,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      finalTranslations[finalLocale.toString()]
                              ?['planeTitle'] ??
                          '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 4.0,
                        constrained: true,
                        panEnabled: true,
                        child: Container(
                          alignment: Alignment.center,
                          child: Transform.rotate(
                            angle: -90 * (3.141592653589793 / 180),
                            alignment: Alignment.center,
                            child: Image.memory(
                              imageBytes2,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
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

  @override
  void actualizarLenguaje(Locale locale) {
    cargarLocaleYTranslations();
  }
}
