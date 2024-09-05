import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/Message.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/result.dart';
import 'package:holdemmanager_app/Models/Feedback/Feedback.dart';
import 'package:holdemmanager_app/Models/Feedback/FeedbackEnum.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _Feedback createState() => _Feedback();
}

class _Feedback extends State<FeedbackScreen> implements LanguageHelper {
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  bool _isAnonimo = false;
  FeedbackEnum _selectedCategory = FeedbackEnum.INSCRIPCION;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
  }

  @override
  void dispose() {
    translationService.removeListener(this);
    _focusNode.dispose();
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

  String traducir(String msg) {
    return finalTranslations[finalLocale.toString()]?[msg] ?? 'Error';
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

        Result result = await FeedbackModel.enviarFeedback(
            message, userId, now, _isAnonimo, _selectedCategory, context);

        if (result.message == 'sesionEx') {
          Message.mostrarMensajeError(traducir('sesionEx'), context);
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
          return;
        }

        Message.mostrarMensajeCorrecto(traducir('feebackValid'), context);
        _feedbackController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoticiasScreen()),
        );
      } catch (e) {
        Message.mostrarMensajeError(traducir('feebackError'), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawerScrimColor: const Color.fromARGB(0, 163, 141, 141),
      drawer: const SideBar(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoticiasScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 25.0),
                child: Text(
                  traducir('leaveFeed'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Focus(
                focusNode: _focusNode,
                child: Builder(
                  builder: (BuildContext context) {
                    return DropdownButtonFormField<FeedbackEnum>(
                      value: _selectedCategory,
                      onChanged: (FeedbackEnum? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      items: FeedbackEnumExtension.values
                          .map((FeedbackEnum category) {
                        return DropdownMenuItem<FeedbackEnum>(
                          value: category,
                          child: Text(category.displayName),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: traducir('category'),
                        labelStyle: TextStyle(
                          color: _focusNode.hasFocus
                              ? Colors.orangeAccent
                              : Colors.grey,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: traducir('writeFeed'),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return traducir('errorFeed');
                  }
                  return null;
                },
                maxLines: 5,
                minLines: 2,
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                title: Text(traducir('sendAnonimo')),
                value: _isAnonimo,
                activeColor: Colors.orangeAccent,
                onChanged: (bool? value) {
                  setState(() {
                    _isAnonimo = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orangeAccent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                  child: Text(
                    traducir('sendFeed'),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
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
