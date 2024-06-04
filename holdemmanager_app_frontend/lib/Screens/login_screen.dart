import 'package:flutter/material.dart';
import 'package:holdemmanager_app/widgets/input_decoration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      // This will trigger a rebuild whenever the focus changes
    });
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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
              cajanaranja(size),
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
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecorations.inputDecoration(
                        hintext: 'ejemplo@hotmail.com',
                        labeltext: 'Correo electronico',
                        icono: const Icon(Icons.alternate_email_rounded),
                      ),
                      validator: (value) {
                        if (!_emailFocusNode.hasFocus) return null;
                        const String pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        final RegExp regExp = RegExp(pattern);
                        return regExp.hasMatch(value ?? '')
                            ? null
                            : 'El valor ingresado no es un correo';
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecorations.inputDecoration(
                        hintext: '********',
                        labeltext: 'Contraseña',
                        icono: const Icon(Icons.lock_outline),
                      ),
                      validator: (value) {
                        if (!_passwordFocusNode.hasFocus) return null;
                        return (value != null && value.length >= 6)
                            ? null
                            : 'La contraseña debe ser mayor o igual a los 6 caracteres';
                      },
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledColor: Colors.grey,
                      color: Colors.orangeAccent,
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
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Do something when the form is valid
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          const Text(
            'Crear una nueva cuenta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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