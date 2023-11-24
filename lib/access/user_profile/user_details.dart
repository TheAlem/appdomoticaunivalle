import 'package:appdomotica/access/def_login.dart';
import 'package:flutter/material.dart';
import 'package:appdomotica/access/database/database_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:appdomotica/access/def_session_manager.dart';
import 'package:appdomotica/access/user_profile/user_session.dart';


class UserDetailsPage extends StatefulWidget {
  final String userEmail;

  const UserDetailsPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    var databaseService = DatabaseService();
    try {
      var details = await databaseService.getUserDetails(widget.userEmail);
      if (mounted) {
        setState(() {
          userDetails = details;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _logoutUser() async {
    try {
      UserSession.setUserEmail('');

      await SessionManager.saveLoginState(false);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginDef()),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al cerrar sesión: $e",
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
        backgroundColor: const Color.fromARGB(228, 82, 2, 2),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (userDetails != null) ...[
                    _dataTile('Nombres', userDetails?['nombres']),
                    _dataTile('Apellidos', userDetails?['apellidos']),
                    _dataTile('Correo Institucional',
                        userDetails?['correo_institucional']),
                    _dataTile('Teléfono', userDetails?['telefono']),
                    _dataTile('Rol', userDetails?['rol']),
                  ] else
                    const Text("No se encontraron detalles del usuario."),
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _logoutUser,
                      child: const Text('Cerrar Sesión'),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(228, 82, 2, 2),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _dataTile(String title, String? value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value ?? 'No disponible'),
    );
  }
}
