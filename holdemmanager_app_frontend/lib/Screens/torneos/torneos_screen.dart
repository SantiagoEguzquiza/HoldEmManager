import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';

class TorneosPage extends StatefulWidget {
  const TorneosPage({super.key});

  @override
  _TorneosPage createState() => _TorneosPage();
}

class _TorneosPage extends State<TorneosPage> implements LanguageHelper {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> torneos;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    torneos = apiService.obtenerTorneos();
  }

  @override
  void dispose() {
    translationService.removeListener(this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(finalTranslations['torneos'] ?? 'Torneos'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: torneos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar los torneos"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay torneos disponibles"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var torneo = snapshot.data![index];
                return ListTile(
                  title: Text(torneo['nombre']),
                  subtitle: Text("Fecha: ${torneo['fecha']}"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(torneo['nombre']),
                        content: Text(
                          "Fecha: ${torneo['fecha']}\n"
                          "Modo de Juego: ${torneo['modo']}\n"
                          "Premios: ${torneo['premios']}",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cerrar"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
