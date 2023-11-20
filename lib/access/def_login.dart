import 'package:appdomotica/interface/interface_list_control.dart';
import 'package:appdomotica/access/def_register.dart';
import 'package:flutter/material.dart';
import 'package:appdomotica/animation/FadeAnimation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;

class LoginDef extends StatefulWidget {
  const LoginDef({Key? key}) : super(key: key);

  @override
  _LoginDefState createState() => _LoginDefState();
}

class _LoginDefState extends State<LoginDef> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  String? _role;
  List<String> _rolesValidos = ['Estudiante', 'Docente', 'Administrador'];
  late Db db;
  late DbCollection usersCollection;

  @override
  void initState() {
    super.initState();
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    db = await Db.create("mongodb://sunset:1234@144.22.36.59:27017/sunset");
    await db.open();
    usersCollection = db.collection('registro');
  }

  void _tryLogin() async {
    String email = _correoController.text.trim();
    String password = _contrasenaController.text;

    if (email.isEmpty || password.isEmpty || _role == null) {
      Fluttertoast.showToast(
        msg: "Por favor, rellena todos los campos.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._]+@est\.univalle\.edu$").hasMatch(email)) {
      Fluttertoast.showToast(
        msg:
            "Por favor, utiliza un correo válido del dominio @est.univalle.edu",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      final user = await usersCollection
          .findOne(where.eq('correo_institucional', email).eq('rol', _role));

      if (user != null && BCrypt.checkpw(password, user['contraseña'])) {
        Fluttertoast.showToast(
          msg: "Inicio de sesión exitoso",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const listInterface()));
      } else {
        Fluttertoast.showToast(
          msg: "Correo, contraseña o rol incorrectos",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error de autenticación: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void dispose() {
    db.close();
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
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
                      child: Image.asset('assets/images/image_univalle.png'),
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
                                controller: _correoController,
                                decoration: const InputDecoration(
                                  hintText: "Correo",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: _contrasenaController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "Contraseña",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField<String>(
                                hint: const Text('Seleccione su rol'),
                                value: _role,
                                items: _rolesValidos.map((String value) {
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
                                    builder: (context) => const registerdef()),
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
