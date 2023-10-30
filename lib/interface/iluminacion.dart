import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IluminacionPage extends StatefulWidget {
  @override
  _IluminacionPageState createState() => _IluminacionPageState();
}

class _IluminacionPageState extends State<IluminacionPage> {
  bool isSwitchedOn = false;
  List<HistorialItem> historial = [];

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
        ),
      );
      if (historial.length > 4) {
        historial = historial.sublist(0, 4);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF9C0444),
        title: Text('Control de Iluminación',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.all(25),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF9C0444),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: toggleSwitch,
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (widget, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: widget,
                              );
                            },
                            child: Icon(
                              isSwitchedOn
                                  ? Icons.lightbulb
                                  : Icons.lightbulb_outline,
                              color: isSwitchedOn
                                  ? Colors.yellow
                                  : Color(0xffffffff),
                              size: 120,
                              key: ValueKey<bool>(isSwitchedOn),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            isSwitchedOn ? 'Encendido' : 'Apagado',
                            style: TextStyle(
                              color: Color(0xfffffffff),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Color(0xFF9C0444),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0,
                            top: 8.0,
                            bottom: 8.0), // ajustado el padding
                        child: Text(
                          'Historial',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: historial.length,
                          itemBuilder: (context, index) => Card(
                            margin: EdgeInsets.all(10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: historial[index].estado ==
                                        'Encendido'
                                    ? [
                                        BoxShadow(
                                          color: Colors.yellow.withOpacity(0.6),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: Offset(0, 0),
                                        )
                                      ]
                                    : [],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('dd/MM/yyyy').format(
                                                historial[index].dateTime),
                                            style: TextStyle(
                                              color: Color(0xFFa01c5c),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('HH:mm').format(
                                                historial[index].dateTime),
                                            style: TextStyle(
                                              color: Color(0xFFa01c5c),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      child: VerticalDivider(
                                        color: Color(0xFFa01c5c),
                                        thickness: 2,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${historial[index].nombre}    ${historial[index].rol}",
                                            style: TextStyle(
                                              color: Color(0xFFa01c5c),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${historial[index].estado}",
                                            style: TextStyle(
                                              color: Color(0xFFa01c5c),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
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
