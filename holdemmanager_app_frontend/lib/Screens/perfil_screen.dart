import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdemmanager_app/NavBar/nav_bar.dart';
import 'package:holdemmanager_app/Screens/home_screen.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String finalName = '';
  String finalEmail = '';
  bool isLoading = true;
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
  ];

  @override
  void initState() {
    super.initState();
    getDatosValidacion();
  }

  Future<void> getDatosValidacion() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final obtenerName = sharedPreferences.getString('name');
    final obtenerEmail = sharedPreferences.getString('email');
    setState(() {
      finalName = obtenerName ?? 'Invitado';
      finalEmail = obtenerEmail ?? 'invitado@example.com';

      isLoading = false;
    });
  }

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
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
          setState(() {
            _selectedIndex = index;
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
                        '$finalName',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 15),
                    Text(
                      '$finalEmail',
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
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
                              onPressed: () {},
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
                        Get.offAll(() => const LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 218, 139, 35),
                      ),
                      child: const Text(
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
}
