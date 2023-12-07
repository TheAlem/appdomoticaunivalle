import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appdomotica/mqtt/mqtt_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IluminacionPage extends StatefulWidget {
  @override
  _IluminacionPageState createState() => _IluminacionPageState();
}

class _IluminacionPageState extends State<IluminacionPage>
  with SingleTickerProviderStateMixin {
  double lightIntensity = 0;
  List<HistorialItem> historial = [];
  MQTTManager? mqttManager;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager('jose_univalle/prueba');
    mqttManager?.connect().then((_) {
      mqttManager?.subscribe();
      handleMqttConnected();
    }).catchError((_) {
      handleMqttDisconnected();
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.yellow,
    ).animate(_animationController);

    _sizeAnimation = Tween<double>(
      begin: 40.0,
      end: 90.0,
    ).animate(_animationController);

    fetchHistorial();
  }

  void handleMqttConnected() {
    setState(() {
      isConnected = true;
    });
  }

  void handleMqttDisconnected() {
    setState(() {
      isConnected = false;
    });
  }

  void updateLightIntensity(double intensity, {bool updateHistorial = false}) {
    int brightness = (intensity * 255).toInt();
    setState(() {
      lightIntensity = intensity;
    });

    _animationController.animateTo(lightIntensity);

    String mensaje = brightness.toString();
    if (isConnected) {
      mqttManager?.publish(mensaje);
      if (updateHistorial || intensity == 0 || intensity == 1.0) {
        addToHistorial();
      }
    } else {
      print(
          "El cliente MQTT no está conectado. No se puede enviar el mensaje.");
    }
  }

  void addToHistorial() {
    setState(() {
      historial.insert(
        0,
        HistorialItem(
          dateTime: DateTime.now(),
          estado: '${(lightIntensity * 100).toInt()}% de Intensidad',
        ),
      );
      if (historial.length > 7) {
        historial = historial.sublist(0, 7);
      }
    });
  }

  Future<void> fetchHistorial() async {
    try {
      final response = await http
          .get(Uri.parse('http://144.22.36.59:8000/historial/prueba'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        List<HistorialItem> fetchedItems =
            data.map((item) => HistorialItem.fromJson(item)).toList();

        fetchedItems.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        if (fetchedItems.length > 7) {
          fetchedItems = fetchedItems.take(7).toList();
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
    _animationController.dispose();
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
          const  SizedBox(height: 40),
            buildLightBulbIcon(),
            buildLightIntensitySlider(),
            buildIntensityText(),
            buildHistorialList(),
          ],
        ),
      ),
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
            'Iluminación',
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

  Widget buildLightBulbIcon() {
    return GestureDetector(
      onTap: () => updateLightIntensity(lightIntensity == 0 ? 1.0 : 0),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              // Agrega una sombra que cambia basada en la intensidad de la luz
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(
                      0.1 * lightIntensity), // Opacidad basada en la intensidad
                  blurRadius:
                      10.0 + (20.0 * lightIntensity), // Radio de difuminado
                  spreadRadius:
                      5.0 + (10.0 * lightIntensity), // Propagación de la sombra
                ),
              ],
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: _colorAnimation.value,
              size: _sizeAnimation.value,
            ),
          );
        },
      ),
    );
  }

  Widget buildLightIntensitySlider() {
    return Slider(
      value: lightIntensity,
      onChanged: (newIntensity) => updateLightIntensity(newIntensity),
      onChangeEnd: (newIntensity) =>
          updateLightIntensity(newIntensity, updateHistorial: true),
      min: 0,
      max: 1,
      divisions: 100,
      label: '${(lightIntensity * 100).toInt()}%',
      activeColor: Color.fromARGB(255, 153, 24, 24),
      inactiveColor: Color.fromARGB(83, 133, 37, 37),
      thumbColor: Color.fromARGB(255, 153, 24, 24),
    );
  }

  Widget buildIntensityText() {
    return Text(
      '${(lightIntensity * 100).toInt()}% de Intensidad',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget buildHistorialList() {
    return Expanded(
      child: ListView.builder(
        itemCount: historial.length,
        itemBuilder: (context, index) {
          // Determina si la intensidad es 0% para cambiar el color del icono
          bool isZeroIntensity = historial[index].estado.startsWith('0%');
          return ListTile(
            leading: Icon(
              Icons.lightbulb_outline,
              color: isZeroIntensity
                  ? Colors.grey
                  : Colors.yellow, // Color gris si la intensidad es 0%
            ),
            title: Text(
              DateFormat('EEEE, d MMMM yyyy, h:mm a')
                  .format(historial[index].dateTime),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              'Intensidad: ${historial[index].estado}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
