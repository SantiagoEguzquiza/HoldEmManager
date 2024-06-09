import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BNavegacion extends StatefulWidget {
  const BNavegacion({super.key});

  @override
  State<BNavegacion> createState() => _BNavegacionState();
}

class _BNavegacionState extends State<BNavegacion> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
  child: FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        SharedPreferences sharedPreferences = snapshot.data!;
        String? accountName = sharedPreferences.getString('name');
        String? accountEmail = sharedPreferences.getString('email');

        return Container( 
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
                      accountName ?? 'Nombre no disponible',
                      style: const TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      accountEmail ?? 'Email no disponible',
                      style: const TextStyle(color: Colors.white),
                    ),
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: Image.asset(
                          'lib/assets/images/default-user.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.map,color: Colors.orangeAccent),
                title: const Text('Mapa del Evento'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.ad_units_rounded,color: Colors.orangeAccent),
                title: const Text('Foro de Noticias'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help_sharp,color: Colors.orangeAccent),
                title: const Text('Recursos Educativos'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.event_available,color: Colors.orangeAccent),
                title: const Text('Torneos'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.people_sharp,color: Colors.orangeAccent),
                title: const Text('Foro de Discusión'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.comment,color: Colors.orangeAccent),
                title: const Text('Comentarios'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app,color: Colors.orangeAccent),
                title: const Text('Cerrar Sesión'),
                onTap: () {},
              ),
            ],
          ),
        );
      }
    },
  ),
);
  }
}
