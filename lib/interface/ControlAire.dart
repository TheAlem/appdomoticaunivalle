import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appdomotica/mqtt/mqtt_manager.dart'; // Asegúrate de que esta ruta es correcta según tu estructura de proyecto

class AirConditionerControlScreen extends StatefulWidget {
  @override
  _AirConditionerControlScreenState createState() =>
      _AirConditionerControlScreenState();
}

class _AirConditionerControlScreenState
    extends State<AirConditionerControlScreen> {
  bool isAcOn = false;
  int temperature = 20; // Temperatura inicial en grados centígrados
  List<HistorialItem> historial = [];
  MQTTManager? mqttManager;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager('jose_univalle/ac'); // Tópico específico para AC
    mqttManager?.connect().then((_) {
      if (mqttManager?.isConnected() ?? false) {
        setState(() {
          isConnected = true;
        });
        mqttManager?.subscribe();
      }
    });
  }

  @override
  void dispose() {
    mqttManager?.disconnect();
    super.dispose();
  }

  void toggleAC() {
    if (isConnected) {
      setState(() {
        isAcOn = !isAcOn;
        addHistorial(isAcOn ? 'Encendido' : 'Apagado');
      });

      String mensaje = isAcOn ? "1" : "0";
      mqttManager?.publish('ac/state/$mensaje');
    }
  }

  void changeTemperature(bool increase) {
    if (isConnected &&
        ((increase && temperature < 30) || (!increase && temperature > 16))) {
      setState(() {
        temperature += increase ? 1 : -1;
        addHistorial('Temp ajustada a $temperature°C');
      });

      mqttManager?.publish('ac/temp/${temperature}');
    }
  }

  void addHistorial(String estado) {
    historial.insert(
      0,
      HistorialItem(
        dateTime: DateTime.now(),
        estado: estado,
        nombre: 'Usuario AC',
        rol: 'Controlador',
      ),
    );
    if (historial.length > 7) {
      historial = historial.sublist(0, 7);
    }
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
          Text(
            'Aire Acondicionado',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Icon(
            isConnected ? Icons.signal_wifi_4_bar : Icons.signal_wifi_off,
            color: isConnected ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget buildAcToggleButton() {
    return GestureDetector(
      onTap: toggleAC,
      child: Icon(
        isAcOn ? Icons.ac_unit : Icons.power_settings_new,
        color: isAcOn ? Colors.blue : Colors.red,
        size: 80,
      ),
    );
  }

  Widget buildTemperatureDisplay() {
    return Text(
      'TEMP: ${temperature}°C',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget buildTemperatureControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: () => changeTemperature(true),
        ),
        SizedBox(width: 20),
        IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () => changeTemperature(false),
        ),
      ],
    );
  }

  Widget buildHistoryList() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildTopBar(context),
            SizedBox(height: 40),
            buildAcToggleButton(),
            SizedBox(height: 20),
            buildTemperatureDisplay(),
            buildTemperatureControlButtons(),
            buildHistoryList(),
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
