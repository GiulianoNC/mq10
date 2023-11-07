import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Herramientas/boton.dart';
import '../Herramientas/variables_globales.dart';

class Primera extends StatefulWidget {

  const Primera({Key? key}) : super(key: key);

  @override
  State<Primera> createState() => _PrimeraState();
}


class _PrimeraState extends State<Primera> {
  int _selectedIndex = 0;
  String razonSocial = "";
  String cuit = "";
  String cliente = "";
  bool loading = false; // Nuevo estado para controlar la visibilidad del indicador de progreso

  final razonSocialController = TextEditingController();
  List<String> suggestions = [];

  // Función para buscar sugerencias de RAZON SOCIAL
  Future<void> buscarSugerencias(String query) async {
    final url = Uri.parse("http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ1002B_ORCH");
    final body = jsonEncode({
      "RAZON_SOCIAL": query,
      "TAX_ID": "",
    });

    final headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)["MQ1002BD_DATAREQ"]["rowset"];
        final suggestionsList = data
            .map<String>((entry) => entry["Razon_Social"].toString())
            .toSet()
            .toList();
        setState(() {
          suggestions = suggestionsList;
        });
      } else {
        print("Error en la solicitud POST: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud POST: $e");
    }
  }
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


  Future<void> buscarCliente() async {
    final url = Uri.parse("http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ1002B_ORCH");
    final body = jsonEncode({
      "RAZON SOCIAL": razonSocial,
      "TAX_ID": cuit,
    });

    final headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, body: body, headers: headers);
      final data = json.decode(response.body);
      var resp = json.decode(response.body).toString();
      print("restuesta es: "+ resp );

      if (response.statusCode == 200) {
        cliente = data["Cliente"];
        cuit = data["Tax_ID"];
        razonSocial = data["Razon_Social"];
        setState(() {});
      } else {
        print("Error en la solicitud POST: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud POST: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  margin: EdgeInsets.fromLTRB(5, 22, 20, 10),
                  //padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  // alignment: Alignment.center,
                  child: Image.asset("images/nombre.png",
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
                  title: Text('Cliente',
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
                  title: Text('Pedidos',
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
                  title: Text('Cobranza',
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
                  title: Text('Configuración',
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

              ],
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fondogris_solo.png'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'IDENTIFICAR CLIENTE',
                  style: TextStyle(
                    color: Color.fromRGBO(102, 45, 145, 30),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25),
                          Center(
                            child: Text(
                              'CUIT',
                              style: TextStyle(
                                color: Color.fromRGBO(102, 45, 145, 30),
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16), // Espacio entre los campos
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: double.infinity, // Ocupar casi todo el ancho del renglón
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: '',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  cuit = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25), // Espacio entre los campos
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'RAZON SOCIAL',
                            style: TextStyle(
                              color: Color.fromRGBO(102, 45, 145, 30),
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: razonSocialController,
                              decoration: InputDecoration(
                                hintText: 'Razon Social',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // Realiza la búsqueda de sugerencias cuando el usuario escribe en el campo
                                buscarSugerencias(value);
                              },
                            ),
                          ),
                        ),
                        // ListView emergente para mostrar las sugerencias
                        suggestions.isNotEmpty
                            ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: suggestions
                                .map(
                                  (suggestion) => ListTile(
                                title: Text(suggestion),
                                onTap: () {
                                  // Cuando el usuario selecciona una sugerencia, actualiza el campo y limpia las sugerencias
                                  setState(() {
                                    razonSocialController.text = suggestion;
                                    suggestions = [];
                                  });
                                },
                              ),
                            )
                                .toList(),
                          ),
                        )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child:
                Column(
                  children: [
                    MyElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/nuevoCliente");
                      },
                      child: Text('NUEVO'),
                    ),
                    SizedBox(height: 100), // Espacio vertical de 20 píxeles entre los botones
                   /* MyElevatedButton(
                      onPressed: buscarCliente,
                      child: Text('BUSCAR'),
                    ),*/
                  ],
                ),

              ),
              SizedBox(height: 10), // Espacio de 10 píxeles
              // Otro contenido aquí si es necesario
            ],
          ),
        ),



        ),
      );
  }
}
