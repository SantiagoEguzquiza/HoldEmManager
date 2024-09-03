import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';

class NotificacionesScreen extends StatefulWidget {
  final int? idJugador;

  const NotificacionesScreen({super.key, required this.idJugador});

  @override
  _NotificacionesScreenState createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen>
    implements LanguageHelper {
  late Future<List<dynamic>> notificaciones;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    notificaciones =
        ApiService().obtenerNotificacionesTorneo(widget.idJugador!);
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
      body: FutureBuilder<List<dynamic>>(
        future: notificaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar notificaciones"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No hay notificaciones disponibles"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var notificacion = snapshot.data![index];
                return ListTile(
                  title: Text(notificacion['mensaje']),
                  subtitle: Text(notificacion['fecha']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
