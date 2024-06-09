import 'package:flutter/material.dart';
import 'package:holdemmanager_app/NavBar/nav_bar.dart';
import 'package:holdemmanager_app/Screens/perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 27, 27, 27),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 53, 53, 53).withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
        ),
      ),
      drawerScrimColor: Colors.transparent,
      drawer: const BNavegacion(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.orangeAccent,
              ),
              label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.orangeAccent,
            ),
            label: 'Perfil',
          ),
        ],
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedLabelStyle: const TextStyle(color: Colors.white70),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PerfilScreen()),
            );
          }
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
