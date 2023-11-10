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

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager('jose_univalle/persianas');
    mqttManager?.connect().then((_) {
      mqttManager?.subscribe();
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
            nombre:'Diego', // Cambie a 'Usuario' ya que no se especificó un nombre.
            rol: 'Docente', // Cambie a 'Residente' para este ejemplo.
          ));
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
                    'Persianas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 48), // Placeholder to center the title
                ],
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
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
            ),
            SizedBox(height: 20),
            Text(
              arePersianasOpen ? 'Abiertas' : 'Cerradas',
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
