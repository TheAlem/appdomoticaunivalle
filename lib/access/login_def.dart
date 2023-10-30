import 'package:appdomotica/access/register_def.dart';
import 'package:flutter/material.dart';
import 'package:appdomotica/animation/FadeAnimation.dart';
import 'package:appdomotica/access/list_interface.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class logindef extends StatefulWidget {
  const logindef({Key? key}) : super(key: key);

  @override
  State<logindef> createState() => _LoginDefState();
}

class _LoginDefState extends State<logindef> {
  String? _email;
  String? _password;
  String? _role;
  List<String> _roles = ['Estudiante', 'Docente', 'Administrador'];

  void _tryLogin() async {
    if (_email == null ||
        _email!.isEmpty ||
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

    if (!RegExp(r"^[a-zA-Z0-9.]+@est\.univalle\.edu$").hasMatch(_email!)) {
      Fluttertoast.showToast(
          msg:
              "Por favor, utiliza un correo válido del dominio @est.univalle.edu",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email!, password: _password!);

      QuerySnapshot userDocs = await FirebaseFirestore.instance
          .collection('registro')
          .where('uid', isEqualTo: userCredential.user!.uid)
          .get();

      if (userDocs.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userDocs.docs.first;
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        String? dbRole = userData?['rol']?.trim().toLowerCase();
        String? inputRole = _role?.trim().toLowerCase();

        print("UID del usuario: ${userCredential.user!.uid}");
        print("Rol en Firestore: $dbRole");
        print("Rol seleccionado en la app: $inputRole");

        if (dbRole == inputRole) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => listInterface()),
          );
        } else {
          Fluttertoast.showToast(
              msg: "El rol no coincide con el registrado.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Usuario no encontrado en Firestore.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";

      if (e.code == 'user-not-found') {
        errorMessage = "El correo electrónico no está registrado.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "La contraseña es incorrecta.";
      } else {
        errorMessage = "Error de autenticación: ${e.message}";
      }
      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
                                  hintText: "Correo",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) => _email = value,
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
                          borderRadius: BorderRadius.circular(
                              50), // Aquí está la corrección
                          color: Color.fromRGBO(225, 0, 2, 1),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          onPressed: _tryLogin,
                          child: const Text(
                            "Iniciar Sesion",
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
