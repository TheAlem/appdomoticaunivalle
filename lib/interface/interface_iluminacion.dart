import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appdomotica/mqtt/mqtt_manager.dart';

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
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.yellow,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad, // Suavizado de la animación
    ));

    _sizeAnimation = Tween<double>(
      begin: 40.0,
      end: 90.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticInOut, // Efecto elástico
    ));
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

  void updateLightIntensity(double intensity) {
    setState(() {
      lightIntensity = intensity;
      historial.insert(
        0,
        HistorialItem(
          dateTime: DateTime.now(),
          estado: '${(lightIntensity * 100).toInt()}% de Intensidad',
          nombre: 'Juan Perez',
          rol: 'Docente',
        ),
      );
      if (historial.length > 7) {
        historial = historial.sublist(0, 7);
      }
    });

    _animationController.animateTo(lightIntensity);

    String mensaje = intensity.toString();
    if (isConnected) {
      mqttManager?.publish(mensaje);
    } else {
      print(
          "El cliente MQTT no está conectado. No se puede enviar el mensaje.");
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
            SizedBox(height: 40),
            buildLightBulbIcon(),
            buildLightIntensitySlider(),
            buildIntensityText(),
            buildHistoryList(),
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
          Text(
            'Iluminación',
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

  Widget buildLightBulbIcon() {
    return GestureDetector(
      onTap: () => updateLightIntensity(lightIntensity == 0 ? 1.0 : 0),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Icon(
            Icons.lightbulb_outline,
            color: _colorAnimation.value,
            size: _sizeAnimation.value,
          );
        },
      ),
    );
  }

  Widget buildLightIntensitySlider() {
    return Slider(
      value: lightIntensity,
      onChanged: (newIntensity) => updateLightIntensity(newIntensity),
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
