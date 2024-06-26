import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Services/api_service.dart';

class RecursosEducativosPage extends StatefulWidget {
  @override
  _RecursosEducativos createState() => _RecursosEducativos();
}

class _RecursosEducativos extends State<RecursosEducativosPage> {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> recursos;

  @override
  void initState() {
    super.initState();
    recursos = apiService.obtenerRecursosEducativos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recursos Educativos'),
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
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                                children: [
                                  const TextSpan(
                                    text: 'Mensaje: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        '${recurso['mensaje'] ?? 'No hay mensaje asignado.'}',
                                  ),
                                ],
                              ),
                            )
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
