import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appdomotica/mqtt/mqtt_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VentanasPage extends StatefulWidget {
  @override
  _VentanasPageState createState() => _VentanasPageState();
}

class _VentanasPageState extends State<VentanasPage> {
  bool isSwitchedOn = false;
  List<HistorialItem> historial = [];
  MQTTManager? mqttManager;
  bool isConnected = false; // Estado de la conexión MQTT

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager('jose_univalle/ventana');
    mqttManager?.connect().then((_) {
      mqttManager?.subscribe();
      setState(() {
        isConnected = true;
      });
      fetchHistorial();
    }).catchError((_) {
      setState(() {
        isConnected = false;
      });
    });
  }

  void toggleSwitch() async {
    String mensaje = isSwitchedOn ? "0" : "1";
    setState(() {
      isSwitchedOn = !isSwitchedOn;
    });

    if (mqttManager?.isConnected() == true) {
      mqttManager?.publish(mensaje);
      await fetchHistorial(); // Actualizar el historial después de cambiar el estado
    } else {
      print(
          "El cliente MQTT no está conectado. No se puede enviar el mensaje.");
    }
  }

  Future<void> fetchHistorial() async {
    try {
      final response = await http
          .get(Uri.parse('http://144.22.36.59:8000/historial/ventana'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        List<HistorialItem> fetchedItems =
            data.map((item) => HistorialItem.fromJson(item)).toList();

        fetchedItems.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        if (fetchedItems.length > 8) {
          fetchedItems = fetchedItems.take(8).toList();
        }

        setState(() {
          historial = fetchedItems;
        });
      } else {
        print(
            'Error al cargar el historial: Código de estado ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar el historial: $e');
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
            buildSwitchControl(),
            SizedBox(height: 20),
            buildSwitchStateText(),
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
            'Ventanas',
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

  Widget buildSwitchControl() {
    return GestureDetector(
      onTap: toggleSwitch,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Icon(
          isSwitchedOn ? Icons.lock_open : Icons.lock,
          color: isSwitchedOn ? Colors.orange : Colors.blue,
          size: 80,
          key: ValueKey<bool>(isSwitchedOn),
        ),
      ),
    );
  }

  Widget buildSwitchStateText() {
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
          bool isClosed = historial[index].estado == "1";
          return ListTile(
            leading: Icon(
              isClosed ? Icons.lock : Icons.lock_open,
              color: isClosed ? Colors.blue : Colors.orange,
            ),
            title: Text(
              DateFormat('EEEE, d MMMM yyyy, h:mm a')
                  .format(historial[index].dateTime),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'Estado: ${isClosed ? "Cerrado" : "Abierto"}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          );
        },
      ),
    );
  }

}

class HistorialItem {
  final DateTime dateTime;
  final String estado;

  HistorialItem({
    required this.dateTime,
    required this.estado,
  });

  factory HistorialItem.fromJson(Map<String, dynamic> json) {
    DateTime fechaHoraUTC =
        DateTime.parse(json['fecha_hora'] as String? ?? '2000-01-01T00:00:00Z');
    DateTime fechaHoraLocal = fechaHoraUTC.subtract(const Duration(hours: 4));

    return HistorialItem(
      dateTime: fechaHoraLocal,
      estado: json['valor'] as String? ?? 'Estado desconocido',
    );
  }
}
