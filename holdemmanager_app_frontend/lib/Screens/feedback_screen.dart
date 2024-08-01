import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Models/FeedbackEnum.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _Feedback createState() => _Feedback();
}

class _Feedback extends State<FeedbackPage> implements LanguageHelper {
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isAnonimo = false;
  FeedbackEnum _selectedCategory = FeedbackEnum.INSCRIPCION;

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

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      final String message = _feedbackController.text;
      final DateTime now = DateTime.now();

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? userId = prefs.getInt('userId');

        if (userId == null) {
          throw Exception('Usuario no autenticado');
        }

        await _apiService.enviarFeedback(
            message, userId, now, _isAnonimo, _selectedCategory);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentario enviado exitosamente!')),
        );
        _feedbackController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al enviar el comentario')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          finalTranslations[finalLocale.toString()]?['comments'] ??
              'Comentarios',
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              DropdownButtonFormField<FeedbackEnum>(
                value: _selectedCategory,
                onChanged: (FeedbackEnum? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items:
                    FeedbackEnumExtension.values.map((FeedbackEnum category) {
                  return DropdownMenuItem<FeedbackEnum>(
                    value: category,
                    child: Text(category.displayName),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Escribe tu comentario',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un comentario';
                  }
                  return null;
                },
                maxLines: 50,
                minLines: 2,
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Text('Enviar como anónimo'),
                value: _isAnonimo,
                onChanged: (bool? value) {
                  setState(() {
                    _isAnonimo = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _submitFeedback,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.orangeAccent),
                ),
                child: const Text(
                  'Enviar feedback',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
