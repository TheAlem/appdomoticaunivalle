import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appdomotica/mqtt/mqtt_manager.dart';

class PersianasPage extends StatefulWidget {
  @override
  _PersianasPageState createState() => _PersianasPageState();
}

class _PersianasPageState extends State<PersianasPage>
    with SingleTickerProviderStateMixin {
  double persianasSpeed = 0; // Valor inicial para la velocidad de las persianas
  List<HistorialItem> historial = [];
  MQTTManager? mqttManager;
  bool isConnected = false;
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _iconAnimation =
        Tween<double>(begin: 50.0, end: 100.0).animate(_animationController);

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

  void updatePersianasSpeed(double speed) {
    int convertedSpeed = ((speed - 0.5) * 510).toInt();
    convertedSpeed = max(-255, min(255, convertedSpeed));

    setState(() {
      persianasSpeed = speed;
      historial.insert(
        0,
        HistorialItem(
          dateTime: DateTime.now(),
          estado: 'Velocidad: $convertedSpeed',
          nombre: 'Usuario',
          rol: 'Residente',
        ),
      );
      if (historial.length > 7) {
        historial = historial.sublist(0, 7);
      }
    });

    _animationController.animateTo(speed);

    String mensaje = convertedSpeed.toString();
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
            buildTopBar(context),
            SizedBox(height: 20), // Espacio ajustado
            buildPersianasAnimation(),
            SizedBox(height: 20), // Espacio ajustado
            buildPersianasSpeedSlider(),
            buildSpeedText(),
            buildHistorialList(),
          ],
        ),
      ),
    );
  }

  Widget buildPersianasAnimation() {
    return AnimatedBuilder(
      animation: _iconAnimation,
      builder: (context, child) {
        return Container(
          height: 100, // Tamaño del contenedor ajustado
          width: 100, // Tamaño del contenedor ajustado
          child: Center(
            child: Icon(
              Icons.vertical_align_center,
              size: _iconAnimation.value, // Tamaño del icono animado
            ),
          ),
        );
      },
    );
  }

  Widget buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 24.0),
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

  Widget buildPersianasSpeedSlider() {
    return Slider(
      value: persianasSpeed,
      onChanged: (newSpeed) => updatePersianasSpeed(newSpeed),
      min: 0,
      max: 1,
      divisions: 100,
      label: '${(persianasSpeed * 100).toInt()}%',
      activeColor: Color.fromARGB(255, 153, 24, 24),
      inactiveColor: Color.fromARGB(83, 133, 37, 37),
      thumbColor: Color.fromARGB(255, 153, 24, 24),
    );
  }

  Widget buildSpeedText() {
    return Text(
      'Velocidad: ${(persianasSpeed * 100).toInt()}%',
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
