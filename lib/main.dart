import 'package:flutter/material.dart';
import 'package:appdomotica/access/def_login.dart';
import '/mqtt/mqtt_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar y conectar MQTTManager
  final mqttManager = MQTTManager("");
  await mqttManager.connect();

  // Iniciar la aplicación Flutter
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDef(),
    );
  }
}
