import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';

class ContactoPage extends StatefulWidget {
  const ContactoPage({super.key});

  @override
  _ContactoPage createState() => _ContactoPage();
}

class _ContactoPage extends State<ContactoPage> implements LanguageHelper {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> contactos;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    contactos = apiService.obtenerContactos();
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
        title: Text(finalTranslations[finalLocale.toString()]?['contact'] ??
            'Contacto'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: contactos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(finalTranslations[finalLocale.toString()]?['noData'] ??
            'No data available'));
            }

            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final contacto = snapshot.data?[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      contacto['direccion'] ?? 'No hay dirección asignada',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height:
                                8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline,
                                color: Colors.orangeAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                contacto['infoCasino'] ??
                                    'No hay información del casino asignada',
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
                            const Icon(Icons.phone, color: Colors.orangeAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                contacto['numeroTelefono'] ??
                                    'No hay teléfono asignado.',
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
                            const Icon(Icons.email, color: Colors.orangeAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                contacto['email'] ?? 'No hay email asignado.',
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
            );
          }
        },
      ),
    );
  }
}
