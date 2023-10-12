import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:appdomotica/animation/FadeAnimation.dart';

class registerdef extends StatefulWidget {
  const registerdef({Key? key}) : super(key: key);

  @override
  State<registerdef> createState() => _RegisterDefState();
}

class _RegisterDefState extends State<registerdef> {
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? _role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xE3520202),
              Color.fromARGB(228, 82, 2, 2),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    1,
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.asset('assets/img/univalle.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeAnimation(
                    1,
                    const Text(
                      "REGÍSTRATE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'MartianMono',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      // Permite desplazamiento
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 30),
                          FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  _buildTextField(
                                      _nombresController,
                                      "Nombres",
                                      (value) => value!.isEmpty
                                          ? 'Ingresa tus nombres'
                                          : null),
                                  _buildTextField(
                                      _apellidosController,
                                      "Apellidos",
                                      (value) => value!.isEmpty
                                          ? 'Ingresa tus apellidos'
                                          : null),
                                  _buildTextField(
                                      _correoController,
                                      "Correo Institucional",
                                      (value) => value!.isEmpty
                                          ? 'Ingresa tu correo'
                                          : null),
                                  _buildTextField(
                                      _telefonoController,
                                      "Teléfono",
                                      (value) => value!.isEmpty
                                          ? 'Ingresa tu teléfono'
                                          : null),
                                  _buildTextField(
                                      _contrasenaController,
                                      "Contraseña",
                                      (value) => value!.isEmpty
                                          ? 'Ingresa tu contraseña'
                                          : null,
                                      isObscure: true),
                                  _buildDropdownField(
                                      "Rol",
                                      [
                                        "Estudiante",
                                        "Docente",
                                        "Administrador"
                                      ],
                                      (value) => value == null
                                          ? 'Selecciona tu rol'
                                          : null),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeAnimation(
                            1.5,
                            Container(
                              height: 50,
                              width: 200,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromARGB(255, 79, 7, 2),
                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    // Procesar los datos
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Por favor, rellena todos los campos.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                },
                                child: const Text(
                                  "Regístrate",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("¿Ya tienes una cuenta? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Inicia sesión aquí",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      String? Function(String?)? validator,
      {bool isObscure = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          errorStyle: const TextStyle(fontSize: 0, height: 0),
          contentPadding: const EdgeInsets.only(top: 15, bottom: 5),
        ),
        validator: validator,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildDropdownField(String hintText, List<String> items,
      String? Function(String?)? validator) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: DropdownButtonFormField<String>(
        hint: Text(hintText, style: TextStyle(fontSize: 14)),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (value) {
          _role = value;
        },
        validator: validator,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          errorStyle: TextStyle(fontSize: 0, height: 0),
          contentPadding: EdgeInsets.only(top: 15, bottom: 5),
        ),
      ),
    );
  }
}
