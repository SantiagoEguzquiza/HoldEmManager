import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';

class ContactoPage extends StatefulWidget {
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
    translationService.addListener(this); // Añade this como listener
    contactos = apiService.obtenerContactos();
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Contacto'),
  //       backgroundColor: Colors.orangeAccent,
  //     ),
  //     body: FutureBuilder<List<dynamic>>(
  //       future: contactos,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else {
  //           if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //             return const Center(child: Text('No hay contactos disponibles'));
  //           }

  //           return ListView.builder(
  //             itemCount: snapshot.data!.length,
  //             itemBuilder: (context, index) {
  //               var contacto = snapshot.data![index];
  //               return ExpansionTile(
  //                 title: Text(
  //                   contacto['direccion'] ?? 'No hay dirección asignada.',
  //                   style: const TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //                 children: [
  //                   Align(
  //                     alignment: AlignmentDirectional.topStart,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           const SizedBox(
  //                               height: 8), // espacio entre elementos
  //                           RichText(
  //                             text: TextSpan(
  //                               style: const TextStyle(
  //                                   fontSize: 16, color: Colors.black87),
  //                               children: [
  //                                 const TextSpan(
  //                                   text: 'Información del casino: ',
  //                                   style:
  //                                       TextStyle(fontWeight: FontWeight.bold),
  //                                 ),
  //                                 TextSpan(
  //                                   text:
  //                                       '${contacto['infoCasino'] ?? 'No hay información del casino asignada.'}',
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(height: 8),
  //                           RichText(
  //                             text: TextSpan(
  //                               style: const TextStyle(
  //                                   fontSize: 16, color: Colors.black87),
  //                               children: [
  //                                 const TextSpan(
  //                                   text: 'Teléfono: ',
  //                                   style:
  //                                       TextStyle(fontWeight: FontWeight.bold),
  //                                 ),
  //                                 TextSpan(
  //                                   text:
  //                                       '${contacto['numeroTelefono'] ?? 'No hay teléfono asignado.'}',
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(height: 8),
  //                           RichText(
  //                             text: TextSpan(
  //                               style: const TextStyle(
  //                                   fontSize: 16, color: Colors.black87),
  //                               children: [
  //                                 const TextSpan(
  //                                   text: 'Email: ',
  //                                   style:
  //                                       TextStyle(fontWeight: FontWeight.bold),
  //                                 ),
  //                                 TextSpan(
  //                                   text:
  //                                       '${contacto['email'] ?? 'No hay email asignado.'}',
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay datos disponibles'));
            }

            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final contacto = snapshot.data?[index];
                return Card(
                  elevation: 4, // agregar sombra al cuadrante
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16), // margen interno
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16), // padding interno
                    title: Text(
                      contacto['direccion'] ?? 'No hay dirección asignada',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height:
                                8), // espacio entre el título y la información
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
