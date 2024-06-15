import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdemmanager_app/Helpers/ErrorMessage.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/perfilHelper.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/home_screen.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> implements LanguageHelper {
  String? finalName;
  String? finalEmail;
  bool isLoading = true;
  int selectedIndex = 1;
  Uint8List? image;
  String? imagePath;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

// Se inicializan la traduccion, se cargan los datos y se agrega a la lista observer
  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    cargarDatos();
  }

  @override
  void dispose() {
    translationService.removeListener(this);
    super.dispose();
  }

  // Datos del Usuario
  Future<void> cargarDatos() async {
    // Carga todos los datos y imagen de perfil del SharedPreferences
    await PerfilHelper.getDatosValidacion();
    await PerfilHelper.cargarImagen(context);

    setState(() {
      finalEmail = PerfilHelper.finalEmail;
      if (finalEmail == '') {
        finalName = null;
        finalEmail = null;
        isLoading = PerfilHelper.isLoading;
        image = null;
        imagePath = null;
      } else {
        finalName = PerfilHelper.finalName;
        finalEmail = PerfilHelper.finalEmail;
        isLoading = PerfilHelper.isLoading;
        image = PerfilHelper.image;
        imagePath = PerfilHelper.imagePath;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawerScrimColor: Colors.transparent,
      drawer: const SideBar(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: Container(
        color: const Color.fromARGB(255, 17, 17, 17),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                      )
                    else
                      Text(
                        finalName ??
                            (finalTranslations[finalLocale.toString()]
                                    ?['nameNotFound'] ??
                                'Nombre no disponible'),
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 15),
                    Text(
                      finalEmail ??
                          (finalTranslations[finalLocale.toString()]
                                  ?['emailNotFound'] ??
                              'Email no disponible'),
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (image != null)
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(image!),
                          )
                        else
                          ClipOval(
                            child: Image.asset(
                              'lib/assets/images/default-user.png',
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: Container(
                            width: 35,
                            height: 43,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.only(left: 2),
                              onPressed: () async {
                                String resultado =
                                    await PerfilHelper.seleccionarImagen(
                                        context);
                                if (finalEmail != null) {
                                  if (resultado == 'imageSaved') {
                                    Message.mostrarMensajeCorrecto(
                                        finalTranslations[finalLocale
                                            .toString()]?['imageSaved'],
                                        context);
                                  } else if (resultado ==
                                      'imageSize') {
                                    Message.mostrarMensajeError(
                                        finalTranslations[finalLocale
                                            .toString()]?['imageSize'],
                                        context);
                                  }
                                  setState(() {
                                    image = PerfilHelper.image;
                                    imagePath = PerfilHelper.imagePath;
                                  });
                                } else {
                                  Message.mostrarMensajeError(
                                      finalTranslations[finalLocale.toString()]
                                          ?['imageValidate'],
                                      context);
                                }
                              },
                              icon: const Icon(Icons.add_a_photo,
                                  color: Color.fromARGB(255, 27, 27, 27)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.remove('isLoggedIn');
                        sharedPreferences.remove('name');
                        sharedPreferences.remove('email');
                        sharedPreferences.remove('${finalEmail}_userImagePath');
                        sharedPreferences.remove('playerNumber');
                        Get.offAll(() => const LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 218, 139, 35),
                      ),
                      child: Text(
                        finalTranslations[finalLocale.toString()]
                                ?['closeSession'] ??
                            'Cerrar Sesión',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}
