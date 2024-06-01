import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(192, 43, 22, 1),
                Color.fromRGBO(247, 150, 59, 1),
              ])),
              width: double.infinity,
              height: size.height * 0.4,
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top:30),
                width: double.infinity,
                child: const Icon(
                  Icons.person_pin,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
