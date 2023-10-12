import 'package:flutter/material.dart';
import 'package:appdomotica/animation/FadeAnimation.dart';
import 'package:appdomotica/register_def.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


class logindef extends StatefulWidget {
  const logindef({Key? key}) : super(key: key);

  @override
  State<logindef> createState() => _logindefState();
}

class _logindefState extends State<logindef> {
  String? _username;
  String? _password;
  String? _role;
  List<String> _roles = ['Estudiante', 'Docente', 'Administrador'];

  void _tryLogin() {
    if (_username == null ||
        _username!.isEmpty ||
        _password == null ||
        _password!.isEmpty ||
        _role == null) {
      Fluttertoast.showToast(
          msg: "Por favor, rellena todos los campos.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    // Código para el inicio de sesión va aquí...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(228, 82, 2, 2),
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
                      "BIENVENIDO",
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
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    FadeAnimation(
                      1.5,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
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
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: "Usuario",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) => _username = value,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "Contraseña",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) => _password = value,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField<String>(
                                hint: const Text('Seleccione su rol'),
                                value: _role,
                                items: _roles.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _role = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FadeAnimation(
                      1.5,
                      Container(
                        height: 50,
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromARGB(255, 79, 7, 2),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: _tryLogin,
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeAnimation(
                      1.5,
                      const Text(
                        "Olvidaste tu contraseña?",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeAnimation(
                      1.5,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "¿Deseas registrarte?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => registerdef()),
                              );
                            },
                            child: const Text(
                              "Regístrate",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
