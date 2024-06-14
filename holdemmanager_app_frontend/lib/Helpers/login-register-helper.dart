import 'package:flutter/material.dart';

class LoginRegisterHelper {
  static SafeArea iconopersona() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  static Container imagen(Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/image-poker.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  static void mostrarSelectorLenguaje(
    BuildContext context,
    Map<String, dynamic> translations,
    Locale locale,
    Function(Locale) onLocaleSelected,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.language),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  translations[locale.toString()]?['selectLanguage'] ??
                      'Select Language',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),

              crearOpcionLenguaje(
                context,
                const Locale('en', 'US'),
                'lib/assets/images/ingles.jpg',
                translations[locale.toString()]?['english'] ?? 'Inglés',
                onLocaleSelected,
              ),
              SizedBox(height: 16),

              crearOpcionLenguaje(
                context,
                const Locale('es', 'ES'),
                'lib/assets/images/español.jpg',
                translations[locale.toString()]?['spanish'] ?? 'Español',
                onLocaleSelected,
              ),
              SizedBox(height: 16),

              crearOpcionLenguaje(
                context,
                const Locale('pt', 'BR'),
                'lib/assets/images/portugues.jpg',
                translations[locale.toString()]?['portuguese'] ?? 'Portugués',
                onLocaleSelected,
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget crearOpcionLenguaje(
    BuildContext context,
    Locale locale,
    String rutaImagen,
    String nombreIdioma,
    Function(Locale) onLocaleSelected,
  ) {
    return GestureDetector(
      onTap: () {
        onLocaleSelected(locale);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Image.asset(
              rutaImagen,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            Text(
              nombreIdioma,
              style:
                  const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
