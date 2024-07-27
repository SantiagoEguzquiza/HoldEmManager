import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RecursosEducativosPage extends StatefulWidget {
  const RecursosEducativosPage({super.key});

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
    translationService.addListener(this);
    recursos = apiService.obtenerRecursosEducativos();
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
        title: Text(
          finalTranslations[finalLocale.toString()]?['educationalResources'] ??
              'Recursos Educativos',
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
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
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.message_rounded,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(width: 8),
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
                            if (recurso['urlImagen'] != null &&
                                recurso['urlImagen'].isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      _mostrarImagenAmpliada(
                                          recurso['urlImagen']);
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.image,
                                          color: Colors.orangeAccent,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Ver imagen',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 16),
                            if (recurso['urlVideo'] != null &&
                                recurso['urlVideo'].isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.videocam,
                                        color: Colors.orangeAccent,
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () async {
                                          final url = recurso['urlVideo'];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'No se pudo abrir el video $url';
                                          }
                                        },
                                        child: const Text(
                                          'Ver video',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
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
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  void _mostrarImagenAmpliada(String? imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: double.infinity,
              child: Image.network(
                imageUrl ?? '',
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
