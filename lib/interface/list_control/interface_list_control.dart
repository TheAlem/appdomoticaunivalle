import 'package:appdomotica/interface/domotica_control/interface_PersianasPage.dart';
import 'package:appdomotica/interface/domotica_control/interface_controlacceso.dart';
import 'package:appdomotica/interface/domotica_control/interface_iluminacion.dart';
import 'package:appdomotica/interface/domotica_control/interface_ventanas.dart';
import 'package:flutter/material.dart';
import 'package:appdomotica/access/user_profile/user_details.dart';
import 'package:appdomotica/access/user_profile/user_session.dart';

class ListInterface extends StatefulWidget {
  const ListInterface({Key? key}) : super(key: key);

  @override
  State<ListInterface> createState() => _ListInterfaceState();
}

class _ListInterfaceState extends State<ListInterface> {
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Univalle Domótica'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(228, 82, 2, 2),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              String currentUserEmail = UserSession.getUserEmail();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserDetailsPage(userEmail: currentUserEmail),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return buildCard(context, index);
        },
      ),
    );
  }

  Widget buildCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _pages[index]['page']),
        );
      },
      child: Card(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        color: const Color.fromARGB(228, 82, 2, 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                _pages[index]['image'],
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _pages[index]['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              _pages[index]['description'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
