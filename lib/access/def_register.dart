import 'package:flutter/material.dart';
import 'package:appdomotica/animation/FadeAnimation.dart';
import 'package:appdomotica/access/def_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State hide Center;

class registerdef extends StatefulWidget {
  const registerdef({Key? key}) : super(key: key);

  @override
  _RegisterDefState createState() => _RegisterDefState();
}

class _RegisterDefState extends State<registerdef> {
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? _role;

  Db? db;
  DbCollection? collection;

  void initState() {
    super.initState();
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    db = await Db.create('mongodb://sunset:1234@144.22.36.59:27017/sunset');
    await db!.open();
    collection = db!.collection('registro');
  }

  String hashPassword(String password) {
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }

  Future<void> registerUser(BuildContext context) async {
    if (!_formkey.currentState!.validate()) return;

    String hashedPassword = hashPassword(_contrasenaController.text);

    try {
      await collection!.insertOne({
        'nombres': _nombresController.text,
        'apellidos': _apellidosController.text,
        'correo_institucional': _correoController.text,
        'telefono': _telefonoController.text,
        'contraseña': hashedPassword,
        'rol': _role,
      });

      Fluttertoast.showToast(
        msg: "Registro exitoso!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginDef()),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

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
                      child: Image.asset('assets/images/image_univalle.png'),
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
                                      _correoController, "Correo Institucional",
                                      (value) {
                                    if (value!.isEmpty) {
                                      return 'Ingresa tu correo';
                                    } else if (!RegExp(
                                            r"^[a-zA-Z0-9.]+@est\.univalle\.edu$")
                                        .hasMatch(value)) {
                                      return 'Por favor, utiliza un correo institucional válido';
                                    }
                                    return null;
                                  }),
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
                          const SizedBox(height: 15),
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
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    await registerUser(context);
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    "Registrarse",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                              height:
                                  20), // Separación entre el botón y el texto.
                          FadeAnimation(
                            1.5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "¿Ya tienes una cuenta?",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginDef()),
                                    );
                                  },
                                  child: const Text(
                                    "Iniciar sesión",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
          errorStyle: const TextStyle(fontSize: 14),
          contentPadding: const EdgeInsets.only(top: 15, bottom: 5),
        ),
        validator: validator,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> items, String? Function(String?)? validator) {
    return DropdownButtonFormField<String>(
      value: _role,
      decoration: const InputDecoration(
        labelText: "Rol",
        errorStyle: TextStyle(fontSize: 14),
      ),
      hint: Text(label),
      onChanged: (newValue) {
        setState(() {
          _role = newValue;
        });
      },
      validator: validator,
      items: items.map((item) {
        return DropdownMenuItem(
          child: Text(item),
          value: item,
        );
      }).toList(),
    );
  }
}
