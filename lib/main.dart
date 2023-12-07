import 'package:flutter/material.dart';
import 'package:appdomotica/access/def_login.dart';
import '/mqtt/mqtt_manager.dart';
import 'package:appdomotica/access/def_session_manager.dart';
import 'package:appdomotica/interface/list_control/interface_list_control.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar y conectar MQTTManager
  final mqttManager = MQTTManager(
      ""); // Asegúrate de reemplazar "tu/topico/aqui" con tu tópico real
  await mqttManager.connect();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLoggedIn;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    isLoggedIn = await SessionManager.getLoginState();
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoading
          ? const SplashScreen() // Una pantalla de carga mientras verifica el estado de la sesión
          : isLoggedIn
              ? const ListInterface()
              : const LoginDef(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // O cualquier otro widget de carga que prefieras
      ),
    );
  }
}
