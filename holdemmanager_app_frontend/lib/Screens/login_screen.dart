import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/result.dart';
import 'package:holdemmanager_app/Screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Models/Usuario.dart';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/login-register-helper.dart';
import 'package:holdemmanager_app/widgets/input_decoration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LanguageHelper {
  final formKey = GlobalKey<FormState>();
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');
  final TextEditingController playerNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
  }

  @override
  void dispose() {
    playerNumberController.dispose();
    passwordController.dispose();
    translationService.removeListener(this);
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
              LoginRegisterHelper.imagen(size),
              LoginRegisterHelper.iconopersona(),
              incioSesionform(context),
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    LoginRegisterHelper.mostrarSelectorLenguaje(
                      context,
                      finalTranslations,
                      finalLocale,
                      (selectedLocale) {
                        setState(() {
                          finalLocale = selectedLocale;
                          Get.updateLocale(selectedLocale);
                          translationService.setLocale(selectedLocale, context);
                        });
                      },
                    );
                  },
                  icon: const Icon(Icons.language, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView incioSesionform(BuildContext context) {
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
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      finalTranslations[finalLocale.toString()]?['login'] ??
                          'Login',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: playerNumberController,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$'))
                      ],
                      autocorrect: false,
                      decoration: InputDecorations.inputDecoration(
                        hintext: finalTranslations[finalLocale.toString()]
                                ?['exampleNumber'] ??
                            '',
                        labeltext: finalTranslations[finalLocale.toString()]
                                ?['playerNumber'] ??
                            'Player Number',
                        icono: const Icon(Icons.person_2_outlined),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: passwordController,
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecorations.inputDecoration(
                        hintext: '********',
                        labeltext: finalTranslations[finalLocale.toString()]
                                ?['password'] ??
                            'Password',
                        icono: const Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 30),
                    isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
                          )
                        : MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            disabledColor: Colors.grey,
                            color: const Color.fromARGB(255, 218, 139, 35),
                            onPressed: (playerNumberController.text.isEmpty ||
                                    passwordController.text.isEmpty)
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final usuario = Usuario(
                                      id: -1,
                                      numberPlayer: int.parse(
                                          playerNumberController.text),
                                      name: '.',
                                      email: '.',
                                      password: passwordController.text,
                                      imageUrl: '.',
                                    );

                                    Result success =
                                        await ApiHandler.login(usuario);

                                    if (success.valid) {
                                      Usuario usuario = await Usuario
                                          .getUsuarioPorNumeroJugador(int.parse(
                                              playerNumberController.text));
                                      final SharedPreferences
                                          sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      sharedPreferences.setInt(
                                          'numberPlayer', usuario.numberPlayer);
                                      sharedPreferences.setString(
                                          'email', usuario.email!);
                                      sharedPreferences.setString(
                                          'name', usuario.name!);
                                      sharedPreferences.setBool(
                                          'isLoggedIn', true);
                                      if (!(usuario.imageUrl == null)) {
                                        sharedPreferences.setString(
                                            '${usuario.email}_userImagePath',
                                            usuario.imageUrl!);
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Get.offAll(() => const HomeScreen());
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            finalTranslations[
                                                        finalLocale.toString()]
                                                    ?[success.message] ??
                                                'Error en el servidor, inténtelo de nuevo mas tarde',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 15),
                              child: Text(
                                finalTranslations[finalLocale.toString()]
                                        ?['signIn'] ??
                                    'Sign In',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
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
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: Text(
              finalTranslations[finalLocale.toString()]?['invitedUser'] ??
                  'Ingresar como invitado',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> cargarLocaleYTranslations() async {
    final Locale? locale = await translationService.getLocale();
    final Map<String, dynamic> translations =
        await translationService.getTranslations();

    setState(() {
      finalTranslations = translations;
      finalLocale = locale ?? const Locale('en', 'US');
    });
  }

  @override
  void actualizarLenguaje(Locale locale) {
    cargarLocaleYTranslations();
  }
}
