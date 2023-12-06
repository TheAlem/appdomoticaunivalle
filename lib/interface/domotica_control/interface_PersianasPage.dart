import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appdomotica/mqtt/mqtt_manager.dart';

class PersianasPage extends StatefulWidget {
  const PersianasPage({super.key});

  @override
  _PersianasPageState createState() => _PersianasPageState();
}

class _PersianasPageState extends State<PersianasPage> {
  bool isPersianasOpen = false; // Estado de las persianas
  List<HistorialItem> historial = [];
  MQTTManager? mqttManager;
  bool isConnected = false; // Estado de la conexión MQTT

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager('jose_univalle/persianas');
    mqttManager?.connect().then((_) {
      setState(() {
        isConnected = true;
      });
      mqttManager?.subscribe();
    }).catchError((_) {
      setState(() {
        isConnected = false;
      });
    });
  }

  void togglePersianas() {
    setState(() {
      isPersianasOpen = !isPersianasOpen;
      historial.insert(
        0,
        HistorialItem(
          dateTime: DateTime.now(),
          estado: isPersianasOpen ? 'Abierto' : 'Cerrado',
          nombre: 'Usuario',
          rol: 'Residente',
        ),
      );
      if (historial.length > 7) {
        historial = historial.sublist(0, 7);
      }
    });

    String mensaje = isPersianasOpen ? "1" : "0";
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
          const  SizedBox(height: 40),
            buildPersianasControl(),
          const  SizedBox(height: 20),
            buildPersianasStateText(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 24.0),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          const Text(
            'Control de Persianas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Icon(
            isConnected ? Icons.signal_wifi_4_bar : Icons.signal_wifi_off,
            color: isConnected ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget buildPersianasControl() {
    return GestureDetector(
      onTap: togglePersianas,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isPersianasOpen ? Icons.vertical_align_center : Icons.horizontal_rule,
          color: isPersianasOpen ? Colors.green : Colors.red,
          size: 80,
          key: ValueKey<bool>(isPersianasOpen),
        ),
      ),
    );
  }

  Widget buildPersianasStateText() {
    return Text(
      isPersianasOpen ? 'Abierto' : 'Cerrado',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget buildHistorialList() {
    return Expanded(
      child: ListView.builder(
        itemCount: historial.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.history, color: Theme.of(context).primaryColor),
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
