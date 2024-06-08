import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String finalName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDatosValidacion();
  }

  Future<void> getDatosValidacion() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final obtenerName = sharedPreferences.getString('name');
    setState(() {
      finalName = obtenerName ?? 'Invitado';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                  )
                : Text(
                    'Bienvenido, $finalName',
                    style: const TextStyle(fontSize: 24),
                  ),
           const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.remove('isLoggedIn');
                sharedPreferences.remove('name');
                Get.offAll(() => const LoginScreen());
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.orangeAccent),
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
