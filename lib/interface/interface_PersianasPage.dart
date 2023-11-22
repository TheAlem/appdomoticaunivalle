import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appdomotica/mqtt/mqtt_manager.dart';

class PersianasPage extends StatefulWidget {
  @override
  _PersianasPageState createState() => _PersianasPageState();
}

class _PersianasPageState extends State<PersianasPage> {
  bool arePersianasOpen = false;
  List<HistorialItem> historial = [];
  MQTTManager? mqttManager;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager('jose_univalle/persianas');
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

  void togglePersianas() {
    setState(() {
      arePersianasOpen = !arePersianasOpen;
      historial.insert(
        0,
        HistorialItem(
          dateTime: DateTime.now(),
          estado: arePersianasOpen ? 'Abiertas' : 'Cerradas',
          nombre: 'Usuario',
          rol: 'Residente',
        ),
      );
      if (historial.length > 8) {
        historial = historial.sublist(0, 8);
      }
    });

    String mensaje = arePersianasOpen ? "1" : "0";
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
            buildPersianasControl(),
            SizedBox(height: 20),
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
        mainAxisAlignment: MainAxisAlignment
            .center, // Asegura que los elementos estén centrados en el eje principal
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 24.0),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(), // Espacio a la izquierda
          const Text(
            'Persianas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          const Spacer(), // Espacio a la derecha
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
        duration: Duration(milliseconds: 300),
        child: Icon(
          arePersianasOpen
              ? Icons.vertical_align_top
              : Icons.vertical_align_bottom,
          color: arePersianasOpen ? Colors.blue : Colors.blueGrey,
          size: 80,
          key: ValueKey<bool>(arePersianasOpen),
        ),
      ),
    );
  }

  Widget buildPersianasStateText() {
    return Text(
      arePersianasOpen ? 'Abiertas' : 'Cerradas',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
