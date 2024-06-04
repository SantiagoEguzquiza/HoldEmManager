import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      routes: {
        'login': (_) => LoginScreen(),
      },
      initialRoute: 'login',
    );
  }
}
