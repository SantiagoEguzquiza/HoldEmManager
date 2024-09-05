import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdemmanager_app/Helpers/Message.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Helpers/login-register-helper.dart';
import 'package:holdemmanager_app/Helpers/result.dart';
import 'package:holdemmanager_app/Models/Dto/CambiarPasswordDTO.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/widgets/input_decoration.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    implements LanguageHelper {
  final formKey = GlobalKey<FormState>();
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');
  final TextEditingController passwordAnteriorController =
      TextEditingController();
  final TextEditingController nuevaPasswordController = TextEditingController();
  final TextEditingController nuevaPasswordRepetirController =
      TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
  }

  @override
  void dispose() {
    passwordAnteriorController.dispose();
    nuevaPasswordController.dispose();
    nuevaPasswordRepetirController.dispose();
    translationService.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoticiasScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
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
              cambiarPasswordForm(context),
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

  SingleChildScrollView cambiarPasswordForm(BuildContext context) {
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
                      finalTranslations[finalLocale.toString()]
                              ?['changePassword'] ??
                          'Cambiar Contraseña',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: passwordAnteriorController,
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecorations.inputDecoration(
                        hintext: '********',
                        labeltext: finalTranslations[finalLocale.toString()]
                                ?['previousPassword'] ??
                            'Contraseña anterior',
                        icono: const Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nuevaPasswordController,
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecorations.inputDecoration(
                        hintext: '********',
                        labeltext: finalTranslations[finalLocale.toString()]
                                ?['newPassword'] ??
                            'Nueva contraseña',
                        icono: const Icon(Icons.lock_outline),
                      ),
                      validator: (value) {
                        if (value == passwordAnteriorController.text) {
                          return finalTranslations[finalLocale.toString()]
                                  ?['passwordsEquals'] ??
                              'Coloca una contraseña que no hayas usado antes';
                        }
                        if (nuevaPasswordController.text.length < 6 &&
                            nuevaPasswordController.text.isNotEmpty) {
                          return finalTranslations[finalLocale.toString()]
                                  ?['passwordLengthValidation'] ??
                              'Confirmar nueva contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nuevaPasswordRepetirController,
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecorations.inputDecoration(
                        hintext: '********',
                        labeltext: finalTranslations[finalLocale.toString()]
                                ?['repeatNewPassword'] ??
                            'Confirmar nueva contraseña',
                        icono: const Icon(Icons.lock_outline),
                      ),
                      validator: (value) {
                        if (value != nuevaPasswordController.text) {
                          return finalTranslations[finalLocale.toString()]
                                  ?['passwordMismatchValidation'] ??
                              'Confirmar nueva contraseña';
                        }
                        return null;
                      },
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
                            onPressed: (passwordAnteriorController
                                        .text.isEmpty ||
                                    nuevaPasswordController.text.isEmpty ||
                                    nuevaPasswordRepetirController.text.isEmpty)
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final cambiarPassword = CambiarPassworDTO(
                                          passwordAnterior:
                                              passwordAnteriorController.text,
                                          nuevaPassword:
                                              nuevaPasswordController.text);

                                      Result success = await CambiarPassworDTO
                                          .cambiarPassword(cambiarPassword, context);

                                      if (success.valid) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Message.mostrarMensajeCorrecto(
                                            finalTranslations[
                                                        finalLocale.toString()]
                                                    ?[success.message] ??
                                                'Contraseña actualizada con éxito',
                                            context);
                                        passwordAnteriorController.text = "";
                                        nuevaPasswordController.text = "";
                                        nuevaPasswordRepetirController.text =
                                            "";
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfileScreen()),
                                        );
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Message.mostrarMensajeError(
                                            finalTranslations[
                                                        finalLocale.toString()]
                                                    ?[success.message] ??
                                                finalTranslations[
                                                        finalLocale.toString()]
                                                    ?['serverError'] ??
                                                'Confirmar nueva contraseña',
                                            context);
                                      }
                                    }
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 15),
                              child: Text(
                                finalTranslations[finalLocale.toString()]
                                        ?['accept'] ??
                                    'Aceptar',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
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
