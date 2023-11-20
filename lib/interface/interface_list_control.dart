import 'package:appdomotica/interface/interface_ControlAire.dart';
import 'package:appdomotica/interface/interface_PersianasPage.dart';
import 'package:appdomotica/interface/interface_controlacceso.dart';
import 'package:appdomotica/interface/interface_iluminacion.dart';
import 'package:appdomotica/interface/interface_ventanas.dart';
import 'package:flutter/material.dart';


class listInterface extends StatefulWidget {
  const listInterface({Key? key}) : super(key: key);

  @override
  State<listInterface> createState() => _listInterfaceState();
}

class _listInterfaceState extends State<listInterface> {
  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Luz',
      'description': 'Control de Iluminación',
      'image': 'assets/images/image_luz.png',
      'page': IluminacionPage(),
    },
    {
      'title': 'Acceso',
      'description': 'Control de Acceso',
      'image': 'assets/images/image_controldeacceso.png',
      'page': AccesoPage(),
    },
    {
      'title': 'Persiana',
      'description': 'Control de Persiana',
      'image': 'assets/images/image_persiana.png',
      'page': PersianasPage(),
    },
    {
      'title': 'Ventana',
      'description': 'Control de Ventana',
      'image': 'assets/images/image_ventana.png',
      'page': VentanasPage(),
    },
    {
      'title': 'Aire Acondicionado',
      'description': 'Control del Aire',
      'image': 'assets/images/image_aire.png',
      'page': AirConditionerControlScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Univalle Domótica'),
        backgroundColor: const Color.fromARGB(228, 82, 2, 2),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _pages[index]['page']),
            ),
            child: Card(
              color: const Color.fromARGB(228, 82, 2, 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: 80,
                      height: 80,
                        child: Image.asset(
                          _pages[index]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                  Text(
                    _pages[index]['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _pages[index]['description'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
