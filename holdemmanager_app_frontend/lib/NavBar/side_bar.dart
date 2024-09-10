import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/login-register-helper.dart';
import 'package:holdemmanager_app/Helpers/perfilHelper.dart';
import 'package:holdemmanager_app/Screens/contacto_screen.dart';
import 'package:holdemmanager_app/Screens/feedback_screen.dart';
import 'package:holdemmanager_app/Screens/forum_screen.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';
import 'package:holdemmanager_app/Screens/map_screen.dart';
import 'package:holdemmanager_app/Screens/rankings/rankings_screen.dart';
import 'package:holdemmanager_app/Screens/notificacionesTorneo/notificaciones_torneo_screen.dart';
import 'package:holdemmanager_app/Screens/recursos/recursos_educativos_screen.dart';
import 'package:holdemmanager_app/Screens/torneos/torneos_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> implements LanguageHelper {
  bool isLoggedIn = false;
  late SharedPreferences preferencias;
  late String nombreUsuario = '';
  late String emailUsuario = '';
  late String imagenUsuario = '';
  late int idUsuario;
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

  Future<void> getPreferencias() async {
    preferencias = await SharedPreferences.getInstance();

    nombreUsuario = preferencias.getString('name') ??
        finalTranslations[finalLocale.toString()]?['nameNotFound'] ??
        'Nombre no disponible';

    emailUsuario = preferencias.getString('email') ??
        finalTranslations[finalLocale.toString()]?['emailNotFound'] ??
        'Correo no disponible';

    imagenUsuario =
        preferencias.getString('${emailUsuario}_userImagePath') ?? '';

    idUsuario = preferencias.getInt('userId') ?? 0;

    isLoggedIn = preferencias.getBool('isLoggedIn') ?? false;
  }

  Widget crearUsuarioImagen() {
    if (imagenUsuario == "null") {
      return const CircleAvatar(
        radius: 45,
        backgroundImage: AssetImage('lib/assets/images/default-user.png'),
      );
    } else if (imagenUsuario.isNotEmpty) {
      return CircleAvatar(
        radius: 45,
        backgroundImage: FileImage(File(imagenUsuario)),
      );
    } else {
      return const CircleAvatar(
        radius: 45,
        backgroundImage: AssetImage('lib/assets/images/default-user.png'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/image-poker.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    height: 250,
                  ),
                ),
                UserAccountsDrawerHeader(
                  accountName: Text(
                    nombreUsuario,
                    style: const TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    emailUsuario,
                    style: const TextStyle(color: Colors.white),
                  ),
                  currentAccountPicture: crearUsuarioImagen(),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
            ListTile(
              leading:
                  const Icon(Icons.event_available, color: Colors.orangeAccent),
              title: Text(finalTranslations[finalLocale.toString()]
                      ?['tournaments'] ??
                  'Torneos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TorneosPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_sharp, color: Colors.orangeAccent),
              title: Text(finalTranslations[finalLocale.toString()]
                      ?['educationalResources'] ??
                  'Recursos Educativos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RecursosEducativosScreen()),
                );
              },
            ),
            if (isLoggedIn) ...[
              ListTile(
                leading: const Icon(Icons.map, color: Colors.orangeAccent),
                title: Text(finalTranslations[finalLocale.toString()]?['map'] ??
                    'Mapa'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.notifications, color: Colors.orangeAccent),
                title: Text(finalTranslations[finalLocale.toString()]
                        ?['notifications'] ??
                    'Notificaciones'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NotificacionesScreen(idJugador: idUsuario),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.comment, color: Colors.orangeAccent),
                title: Text(finalTranslations[finalLocale.toString()]
                        ?['comments'] ??
                    'Comentarios'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeedbackScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.leaderboard_outlined,
                    color: Colors.orangeAccent),
                title: Text(finalTranslations[finalLocale.toString()]
                        ?['ranking'] ??
                    'Ranking'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RankingPage()),
                  );
                },
              ),
              // ListTile(
              //   leading:
              //       const Icon(Icons.people_sharp, color: Colors.orangeAccent),
              //   title: Text(finalTranslations[finalLocale.toString()]
              //           ?['discussionForum'] ??
              //       'Foro de Discusión'),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const ForumScreen()),
              //     );
              //   },
              // ),
            ],
            ListTile(
              leading:
                  const Icon(Icons.contact_page, color: Colors.orangeAccent),
              title: Text(finalTranslations[finalLocale.toString()]
                      ?['contact'] ??
                  'Contacto'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactoScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.orangeAccent),
              title: Text(finalTranslations[finalLocale.toString()]
                      ?['changeLanguage'] ??
                  'Cambiar Idioma'),
              onTap: () {
                LoginRegisterHelper.mostrarSelectorLenguaje(
                  context,
                  finalTranslations,
                  finalLocale,
                  (selectedLocale) {
                    setState(() {
                      finalLocale = selectedLocale;
                      Get.updateLocale(selectedLocale);
                      translationService.setLocale(selectedLocale, context);
                    });
                  },
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.exit_to_app, color: Colors.orangeAccent),
              title: Text(
                isLoggedIn
                    ? (finalTranslations[finalLocale.toString()]
                            ?['closeSession'] ??
                        'Cerrar Sesión')
                    : (finalTranslations[finalLocale.toString()]?['login'] ??
                        'Iniciar Sesión'),
              ),
              onTap: () {
                if (isLoggedIn) {
                  PerfilHelper.cerrarSesion();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }
              },
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
    getPreferencias();
  }
}
