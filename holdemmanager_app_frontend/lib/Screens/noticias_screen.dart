import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';
import 'package:intl/intl.dart';

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  _Noticias createState() => _Noticias();
}

class _Noticias extends State<NoticiasPage> implements LanguageHelper {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> noticias;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this); // Añade this como listener
    noticias = apiService.obtenerNoticias();
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
        title: Text(
          finalTranslations[finalLocale.toString()]?['newsForum'] ?? 'Noticias',
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: noticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay noticias disponibles'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var noticia = snapshot.data![index];
                var fechaFormateada = '';
                if (noticia['fecha'] != null) {
                  var fecha = DateTime.parse(noticia['fecha']);
                  fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);
                }

                return ExpansionTile(
                  title: Text(
                    noticia['titulo'] ?? 'No hay título asignado.',
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
                                  Icons.calendar_month_outlined,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    fechaFormateada.isNotEmpty
                                        ? fechaFormateada
                                        : 'No hay fecha asignada.',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
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
                                    noticia['mensaje'] ??
                                        'No hay mensaje asignado.',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            if (noticia['urlImagen'] != null &&
                                noticia['urlImagen'].isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      _mostrarImagenAmpliada(
                                          noticia['urlImagen']);
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
