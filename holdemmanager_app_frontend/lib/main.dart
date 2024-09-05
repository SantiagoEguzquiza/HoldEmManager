import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  String? tokenExpiryStr = prefs.getString('tokenExpiry');
  if (tokenExpiryStr != null) {
    DateTime tokenExpiry = DateTime.parse(tokenExpiryStr);
    if (DateTime.now().isAfter(tokenExpiry)) {
      isLoggedIn = false;
      await prefs.setBool('isLoggedIn', false);
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.orangeAccent,
          selectionColor: Colors.orangeAccent,
          selectionHandleColor: Colors.orangeAccent,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: isLoggedIn ? const NoticiasScreen() : const LoginScreen(),
    );
  }
}
