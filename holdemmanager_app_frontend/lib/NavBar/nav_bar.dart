import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BNavegacion extends StatefulWidget {
  const BNavegacion({Key? key}) : super(key: key);

  @override
  State<BNavegacion> createState() => _BNavegacionState();
}

class _BNavegacionState extends State<BNavegacion> {
  late SharedPreferences preferencias;
  late String nombreUsuario = '';
  late String emailUsuario = '';
  late String imagenUsuario = '';

  @override
  void initState() {
    super.initState();
    getPreferencias();
  }

  Future<void> getPreferencias() async {
    preferencias = await SharedPreferences.getInstance();
    setState(() {
      nombreUsuario =
          preferencias.getString('name') ?? 'Nombre no disponible';
      emailUsuario =
          preferencias.getString('email') ?? 'Correo no disponible';
      imagenUsuario = preferencias.getString('${emailUsuario}_userImagePath') ?? '';
    });
  }

  Widget crearUsuarioImagen() {
    if (imagenUsuario.isNotEmpty) {
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
              leading: const Icon(Icons.map, color: Colors.orangeAccent),
              title: const Text('Mapa del Evento'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.ad_units_rounded,
                  color: Colors.orangeAccent),
              title: const Text('Foro de Noticias'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_sharp, color: Colors.orangeAccent),
              title: const Text('Recursos Educativos'),
              onTap: () {},
            ),
            ListTile(
              leading:
                  const Icon(Icons.event_available, color: Colors.orangeAccent),
              title: const Text('Torneos'),
              onTap: () {},
            ),
            ListTile(
              leading:
                  const Icon(Icons.people_sharp, color: Colors.orangeAccent),
              title: const Text('Foro de Discusión'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.comment, color: Colors.orangeAccent),
              title: const Text('Comentarios'),
              onTap: () {},
            ),
            ListTile(
              leading:
                  const Icon(Icons.exit_to_app, color: Colors.orangeAccent),
              title: const Text('Cerrar Sesión'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}