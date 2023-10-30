import 'package:flutter/material.dart';
import 'package:appdomotica/interface/controlacceso.dart';
import 'package:appdomotica/interface/iluminacion.dart';

class listInterface extends StatefulWidget {
  const listInterface({Key? key}) : super(key: key);

  @override
  State<listInterface> createState() => _listInterfaceState();
}

class _listInterfaceState extends State<listInterface> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Aplicación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccesoPage(),
                  ),
                );
              },
              child: const Text('Ir a Acceso Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IluminacionPage(),
                  ),
                );
              },
              child: const Text('Ir a Iluminación Page'),
            ),
          ],
        ),
      ),
    );
  }
}
