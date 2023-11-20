import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appdomotica/mqtt/mqtt_manager.dart';

class IluminacionPage extends StatefulWidget {
  @override
  _IluminacionPageState createState() => _IluminacionPageState();
}

class _IluminacionPageState extends State<IluminacionPage> {
  bool isSwitchedOn = false;
  List<HistorialItem> historial = [];
  MQTTManager? mqttManager;

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager('jose_univalle/prueba');
    mqttManager?.connect().then((_) {
      mqttManager?.subscribe();
    });
  }

  void toggleSwitch() {
    setState(() {
      isSwitchedOn = !isSwitchedOn;
      historial.insert(
          0,
          HistorialItem(
            dateTime: DateTime.now(),
            estado: isSwitchedOn ? 'Encendido' : 'Apagado',
            nombre: 'Juan Perez',
            rol: 'Docente',
          ));
      if (historial.length > 8) {
        historial = historial.sublist(0, 8);
      }
    });

    String mensaje = isSwitchedOn ? "1" : "0";

    if (mqttManager?.isConnected() == true) {
      mqttManager?.publish(mensaje);
    } else {
      print(
          "El cliente MQTT no está conectado. No se puede enviar el mensaje.");
    }
  }

  @override
  void dispose() {
    mqttManager?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24.0),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    'Iluminación',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 48), // Placeholder to center the title
                ],
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: toggleSwitch,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Icon(
                  isSwitchedOn ? Icons.lightbulb : Icons.lightbulb_outline,
                  color: isSwitchedOn ? Colors.yellow : Colors.grey,
                  size: 80,
                  key: ValueKey<bool>(isSwitchedOn),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              isSwitchedOn ? 'Encendido' : 'Apagado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: historial.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(historial[index].nombre),
                    subtitle: Text(
                      '${DateFormat('dd/MM/yyyy HH:mm').format(historial[index].dateTime)} - ${historial[index].estado}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistorialItem {
  final DateTime dateTime;
  final String estado;
  final String nombre;
  final String rol;

  HistorialItem({
    required this.dateTime,
    required this.estado,
    required this.nombre,
    required this.rol,
  });
}
