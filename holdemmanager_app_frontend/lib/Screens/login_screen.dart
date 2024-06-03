import 'package:flutter/material.dart';
import 'package:holdemmanager_app/widgets/input_decoration.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [cajanaranja(size), iconopersona(), loginform(context)],
        ),
      ),
    );
  }

  SingleChildScrollView loginform(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    )
                  ]),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Inicio de Sesión',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 30),
                  Container(
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                              autocorrect: false,
                              decoration: InputDecorations.inputDecoration(
                                  hintext: 'ejemplo@hotmail.com',
                                  labeltext: 'Correo electronico',
                                  icono:
                                      const Icon(Icons.alternate_email_rounded))),
                          const SizedBox(height: 30),
                          TextFormField(
                              autocorrect: false,
                              decoration: InputDecorations.inputDecoration(
                                  hintext: '********',
                                  labeltext: 'Contraseña',
                                  icono: const Icon(Icons.lock_outline))),
                          const SizedBox(height: 30)
                        ],
                      ),
                    ),
                  )
                ],
              )),
          const SizedBox(height: 50),
          const Text('Crear una nueva cuenta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  SafeArea iconopersona() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  Container cajanaranja(Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/image-poker.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
