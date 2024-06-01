import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      routes: {
        'login': (_) => LoginScreen(),
      },
      initialRoute: 'login',
    );
  }
}
