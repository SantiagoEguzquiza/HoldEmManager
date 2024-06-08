import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/result.dart';
import 'package:holdemmanager_app/Screens/home_screen.dart';
import 'package:holdemmanager_app/Screens/register_screeen.dart';
import 'package:holdemmanager_app/widgets/input_decoration.dart';
import 'package:holdemmanager_app/Models/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              imagen(size),
              iconopersona(),
              loginform(context),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView loginform(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 280),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Inicio de Sesión',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController, 
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecorations.inputDecoration(
                        hintext: 'ejemplo@hotmail.com',
                        labeltext: 'Correo electrónico',
                        icono: const Icon(Icons.alternate_email_rounded),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _passwordController,
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecorations.inputDecoration(
                        hintext: '********',
                        labeltext: 'Contraseña',
                        icono: const Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledColor: Colors.grey,
                      color: Colors.orangeAccent,
                      onPressed: (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty)
                          ? null
                          : () async {
                              final usuario = Usuario(
                                id: 0,
                                name: '.',
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              Result success = await ApiHandler.login(usuario);
                              if (success.valid) {
                                Usuario usuario = await Usuario.getUsuarioPorEmail(_emailController.text);
                                final SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.setString(
                                    'name', usuario.name!);
                                sharedPreferences.setBool('isLoggedIn', true);
                                Get.offAll(() => const HomeScreen());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success.message,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 15,
                        ),
                        child: const Text(
                          'Ingresar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
            child: const Text(
              'Crear una nueva cuenta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
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

  Container imagen(Size size) {
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
