import 'package:flutter/material.dart';
import 'package:appdomotica/access/login_def.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '/mqtt/mqtt_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar y conectar MQTTManager
  final mqttManager = MQTTManager(
      "tu/topico/aqui"); // Asegúrate de reemplazar "tu/topico/aqui" con tu tópico real
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
      home:
          logindef(), // Asegúrate de que 'LoginDef' sea el widget correcto para iniciar tu aplicación
    );
  }
}
