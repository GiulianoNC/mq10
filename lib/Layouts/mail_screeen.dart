import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Herramientas/boton.dart';
import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({Key? key}) : super(key: key);

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  String userEmail = ''; // Variable para almacenar el correo electrónico ingresado por el usuario
  bool loading = false; // Estado para controlar la visibilidad del indicador de progreso
  int _selectedIndex = 0;

  Future<void> sendData() async {
    setState(() {
      loading = true; // Mostrar indicador de progreso al enviar la solicitud
    });

    late var api = "/jderest/v3/orchestrator/MQ1002N_ORCH";

    var url = Uri.parse(direc + api);
    final body = jsonEncode({
      "username": usuarioGlobal,
      "password": contraGlobal,
      "Cliente": "64979",
      "Correo": userEmail, // Utiliza el correo electrónico ingresado por el usuario

    });

    final headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };
    final response = await http.post(url, body: body, headers: headers);

    print("datos "+ usuarioGlobal + contraGlobal);



    setState(() {
      loading = false; // Oculta el indicador de progreso después de la solicitud
    });

    if (response.statusCode == 200) {
      correoGlobal = userEmail;
      // Si la solicitud es exitosa, muestra un AlertDialog con un mensaje de éxito
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('SUCCESS'),
            content: const Text('envío éxitoso'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el AlertDialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Si hay un error en la solicitud, muestra un mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to send request. Status Code: ${response.statusCode}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el AlertDialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  late Map<String, String> translations = {};

  void initState() {
    super.initState();

    if (!isEnglish) {
      translations = {
        'CONFIRMAR': 'CONFIRMAR',
        //menu
        'VENTA DIRECTA': 'VENTA DIRECTA',
        'Cliente': 'Cliente',
        'Pedidos': 'Pedidos',
        'Cobranza': 'Cobranza',
        'Configuración': 'Configuración',
      };
    } else {
      translations = {
        'CONFIRMAR': 'CONFIRM',
        //menu
        'VENTA DIRECTA': 'DIRECT SELLING',
        'Cliente': 'Customer',
        'Pedidos': 'Orders',
        'Cobranza': 'Billing',
        'Configuración': 'Settings',
      };
    }
  }

  //menu desplegable
  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Cierra el menú lateral
    // Agrega la lógica para navegar a las pantallas correspondientes aquí
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/congrats");
        break;
      case 1:
        Navigator.pushNamed(context, "/mail");
        break;
      case 2:
        Navigator.pushNamed(context, "/pedidos");
        break;
      case 3:
        Navigator.pushNamed(context, "/cobranza");
        break;
      case 4:
        Navigator.pushNamed(context, "/login");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:       Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[
                  Color.fromRGBO(102, 45, 145, 30),
                  Color.fromRGBO(212, 20, 90, 50),
                ],
              ),
            ),
          ),
          title: Row(
              children:[
                Container(
                  margin: EdgeInsets.fromLTRB(5, 30, 20, 10),
                  //padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  // alignment: Alignment.center,
                  child: Image.asset("images/texto_vtadirecta.png",
                    width: 150,
                    height: 50,
                  ),
                ),
                Expanded(child: Container()), // Esto empujará el ícono hacia la derecha
                Padding(
                  padding: EdgeInsets.only(top: 10, right: 10), // Ajusta estos valores según tus preferencias
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.grey, // Cambia el color del ícono de flecha
                  ),
                ),
              ]
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.0),
            child: const SizedBox(),
          ),
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent, // Establece el fondo del Drawer como transparente
            ),
            width: MediaQuery.of(context).size.width / 8, // Define el ancho deseado (1/4 de la pantalla)
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: <Color>[
                        Color.fromRGBO(102, 45, 145, 30),
                        Color.fromRGBO(212, 20, 90, 50),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/nombre2.png',
                        width: 150,
                        height: 70,
                      ),
                      Text(
                        '\nQTM - VENTA  DIRECTA\n\n',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    translations['Cliente'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    _onMenuItemSelected(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(' Mail',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  selected: _selectedIndex == 1,
                  onTap: () {
                    _onMenuItemSelected(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.checklist,
                    color: Colors.grey, // Cambia el color del icono
                  ),
                  title: Text(
                    translations['Pedidos'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  selected: _selectedIndex == 2,
                  onTap: () {
                    _onMenuItemSelected(2);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on,
                    color: Colors.grey, // Cambia el color del icono
                  ),
                  title: Text(
                    translations['Cobranza'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  selected: _selectedIndex == 3,
                  onTap: () {
                    _onMenuItemSelected(3);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings,
                    color: Colors.grey, // Cambia el color del icono
                  ),
                  title: Text(
                    translations['Configuración'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  selected: _selectedIndex == 4,
                  onTap: () {
                    _onMenuItemSelected(4);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: ' Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    userEmail = value; // Actualiza el valor del correo electrónico ingresado
                  });
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                child:   MyElevatedButton(
                  onPressed: ()  async {
                    sendData();
                  },
                  child: Ink(
                      child: Stack(
                        alignment: Alignment.center,
                        children:[
                          Container(
                            padding: const EdgeInsets.all(10),
                            //  constraints: const BoxConstraints(minWidth: 88.0),
                            child:  Text(
                                translations['CONFIRMAR'] ?? '',
                                textAlign: TextAlign.center),
                          ),
                          if (loading)
                            CircularProgressIndicator(), // Indicador de progreso (visible cuando loading es true)
                        ],)
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

