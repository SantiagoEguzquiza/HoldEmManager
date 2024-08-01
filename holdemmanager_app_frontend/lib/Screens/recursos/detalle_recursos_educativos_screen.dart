import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Models/Recurso.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleRecursoScreen extends StatefulWidget {
  final RecursosEducativos recurso;

  const DetalleRecursoScreen({super.key, required this.recurso});

  @override
  _DetalleRecursoScreenState createState() => _DetalleRecursoScreenState();
}

class _DetalleRecursoScreenState extends State<DetalleRecursoScreen>
    implements LanguageHelper {
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
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

  String traducir(String key) {
    return finalTranslations[finalLocale.toString()]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.4),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 231, 229, 229),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.recurso.urlImagen != null &&
                  widget.recurso.urlImagen!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.recurso.urlImagen!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                widget.recurso.titulo,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.recurso.mensaje,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              if (widget.recurso.urlVideo != null &&
                  widget.recurso.urlVideo!.isNotEmpty)
                GestureDetector(
                  onTap: () async {
                    final url = widget.recurso.urlVideo!;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    traducir('watchVideo'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}