import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appdomotica/mqtt/mqtt_manager.dart';

class AccesoPage extends StatefulWidget {
  @override
  _AccesoPageState createState() => _AccesoPageState();
}

class _AccesoPageState extends State<AccesoPage> {
  bool isSwitchedOn = false;
  List<HistorialItem> historial = [];
  MQTTManager? mqttManager;
  bool isConnected = false; // Estado de la conexión MQTT

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager('jose_univalle/puerta');
    mqttManager?.connect().then((_) {
      mqttManager?.subscribe();
      setState(() {
        isConnected = true;
      });
    }).catchError((_) {
      setState(() {
        isConnected = false;
      });
    });
  }

  void toggleSwitch() {
    setState(() {
      isSwitchedOn = !isSwitchedOn;
      historial.insert(
        0,
        HistorialItem(
          dateTime: DateTime.now(),
          estado: isSwitchedOn ? 'Desbloqueado' : 'Bloqueado',
          nombre: 'Juan Perez',
          rol: 'Administrador',
        ),
      );
      if (historial.length > 8) {
        historial = historial.sublist(0, 8);
      }
    });

    String mensaje = isSwitchedOn ? "260" : "259";
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
            buildTopBar(),
            SizedBox(height: 40),
            buildLockControl(),
            SizedBox(height: 20),
            buildLockStateText(),
            buildHistorialList(),
          ],
        ),
      ),
    );
  }

  Widget buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 24.0),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          const Text(
            'Puerta',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          const Spacer(),
          Icon(
            isConnected ? Icons.signal_wifi_4_bar : Icons.signal_wifi_off,
            color: isConnected ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget buildLockControl() {
    return GestureDetector(
      onTap: toggleSwitch,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Icon(
          isSwitchedOn ? Icons.lock_open : Icons.lock,
          color: isSwitchedOn ? Colors.green : Colors.red,
          size: 80,
          key: ValueKey<bool>(isSwitchedOn),
        ),
      ),
    );
  }

  Widget buildLockStateText() {
    return Text(
      isSwitchedOn ? 'Desbloqueado' : 'Bloqueado',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget buildHistorialList() {
    return Expanded(
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
