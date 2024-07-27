import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Models/Noticia.dart';
import 'package:intl/intl.dart';

class DetalleNoticiaScreen extends StatelessWidget {
  final Noticia noticia;

  const DetalleNoticiaScreen({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    var fechaFormateada = DateFormat('dd/MM/yyyy').format(noticia.fecha);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.4),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 231, 229, 229),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noticia.titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
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
            if (noticia.idImagen != null && noticia.idImagen!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  noticia.idImagen!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 10),
            Text(
              noticia.mensaje,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}