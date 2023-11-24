import 'package:flutter/material.dart';
import 'package:appdomotica/access/def_login.dart';
import '/mqtt/mqtt_manager.dart';
import 'package:appdomotica/access/def_session_manager.dart';
import 'package:appdomotica/interface/list_control/interface_list_control.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar y conectar MQTTManager
  final mqttManager = MQTTManager(""); // Asegúrate de reemplazar "tu/topico/aqui" con tu tópico real
  await mqttManager.connect();

  // Verificar el estado de la sesión
  bool isLoggedIn = await SessionManager.getLoginState();

  // Iniciar la aplicación Flutter
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? const listInterface()
          : const LoginDef(), // Usar la variable no constante aquí
    );
  }
}
