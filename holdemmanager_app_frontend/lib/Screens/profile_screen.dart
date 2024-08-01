import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/message.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/perfilHelper.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/change_password_screen.dart';
import 'package:holdemmanager_app/Screens/home_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    implements LanguageHelper {
  String? finalName;
  String? finalEmail;
  bool isLoggedIn = false;
  bool isLoading = true;
  int selectedIndex = 1;
  Uint8List? image;
  String? imagePath;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

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

  Future<void> cargarDatos() async {
    await PerfilHelper.getDatosValidacion();
    await PerfilHelper.cargarImagen(context);

    setState(() {
      isLoggedIn = PerfilHelper.isLoggedIn;
      if (!isLoggedIn) {
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
                          top: 88,
                          right: 80,
                          child: Container(
                            width: 35,
                            height: 40,
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
                                if (finalEmail != null) {
                                  String resultado =
                                      await PerfilHelper.eliminarImagen();
                                  if (resultado == 'imageDeleted') {
                                    Message.mostrarMensajeCorrecto(
                                        finalTranslations[
                                            finalLocale.toString()]?[resultado],
                                        context);
                                    setState(() {
                                      image = null;
                                      imagePath = null;
                                    });
                                  } else if (resultado == 'imageDeletedError') {
                                    Message.mostrarMensajeError(
                                        finalTranslations[
                                            finalLocale.toString()]?[resultado],
                                        context);
                                  }
                                } else {
                                  Message.mostrarMensajeError(
                                      finalTranslations[finalLocale.toString()]
                                          ?['imageValidateDeleted'],
                                      context);
                                }
                              },
                              icon: const Icon(Icons.delete,
                                  color: Color.fromARGB(255, 27, 27, 27)),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: Row(
                            children: [
                              Container(
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
                                    if (finalEmail != null) {
                                      String resultado =
                                          await PerfilHelper.seleccionarImagen(
                                              context);
                                      if (resultado == 'imageSaved') {
                                        Message.mostrarMensajeCorrecto(
                                            finalTranslations[finalLocale
                                                .toString()]?['imageSaved'],
                                            context);
                                      } else if (resultado == 'imageSize') {
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
                                          finalTranslations[finalLocale
                                              .toString()]?['imageValidate'],
                                          context);
                                    }
                                  },
                                  icon: const Icon(Icons.add_a_photo,
                                      color: Color.fromARGB(255, 27, 27, 27)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      PerfilHelper.cerrarSesion();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 218, 139, 35),
                                    ),
                                    child: Text(
                                      !isLoggedIn
                                          ? (finalTranslations[finalLocale
                                                  .toString()]?['login'] ??
                                              'Iniciar Sesión')
                                          : (finalTranslations[
                                                      finalLocale.toString()]
                                                  ?['closeSession'] ??
                                              'Cerrar Sesión'),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  isLoggedIn
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ChangePasswordScreen()));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 218, 139, 35),
                                          ),
                                          child: Text(
                                            (finalTranslations[
                                                        finalLocale.toString()]
                                                    ?['changePassword'] ??
                                                'Cambiar Contraseña'),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      : Container(),
                                ])
                          ]),
                    )
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
