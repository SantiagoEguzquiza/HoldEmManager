import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';

class RecursosEducativosPage extends StatefulWidget {
  @override
  _RecursosEducativos createState() => _RecursosEducativos();
}

class _RecursosEducativos extends State<RecursosEducativosPage>
    implements LanguageHelper {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> recursos;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this); // Añade this como listener
    recursos = apiService.obtenerRecursosEducativos();
  }

  @override
  void dispose() {
    translationService.removeListener(this); // Remueve this como listener
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
        title: Text(finalTranslations[finalLocale.toString()]
                ?['educationalResources'] ??
            'Recursos Educativos'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        // lista recursos
        future: recursos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No hay recursos educativos disponibles'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var recurso = snapshot.data![index];
                return ExpansionTile(
                  title: Text(
                    recurso['titulo'] ?? 'No hay título asignado.',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Align(
                      alignment:
                          AlignmentDirectional.topStart, // contenido a la izq
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, //texto a la izq
                          children: [
                            const SizedBox(
                                height: 8), // espacio entre elementos
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.message_rounded, // Icono de mensaje
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(
                                    width:
                                        8), // Espacio entre el ícono y el texto
                                Expanded(
                                  child: Text(
                                    recurso['mensaje'] ??
                                        'No hay mensaje asignado.',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
