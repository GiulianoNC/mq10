import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mq10/Herramientas/global.dart';
import 'package:mq10/Layouts/pedidos/pedidoNuevo2_screen.dart';
import 'package:provider/provider.dart';

import '../../Herramientas/boton.dart';
import '../../Herramientas/variables_globales.dart';
import '../actualizacion.dart';


class PedidoNuevo extends StatefulWidget {
  const PedidoNuevo({Key? key}) : super(key: key);

  @override
  State<PedidoNuevo> createState() => _PedidoNuevoState();
}

class _PedidoNuevoState extends State<PedidoNuevo> {
  int _selectedIndex = 0;
  bool loading = false; // Nuevo estado para controlar la visibilidad del indicador de progreso

  // Valores seleccionados para los menús
  String? selectedOptionMenu1;
  String? selectedOptionMenu2;
  String? selectedOptionMenu3;

  // Datos de las respuestas de las solicitudes
  List<dynamic>? menu1Options;
  List<dynamic>? menu2Options;
  List<dynamic>? menu3Options;

  var baseUrl = direc;

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
  late Map<String, String> translations = {};

  @override
  void initState() {
    super.initState();
    // Realizar solicitudes para obtener las opciones de los menús
    final pedidoModel = Provider.of<PedidoModel>(context, listen: false);

    // Verificar si hay datos disponibles en el provider
    if (pedidoModel.menu1Options != null &&
        pedidoModel.menu2Options != null &&
        pedidoModel.menu3Options != null) {
      // Si hay datos en el provider, utilizar esos datos
      setState(() {
        menu1Options = pedidoModel.menu1Options;
        menu2Options = pedidoModel.menu2Options;
        menu3Options = pedidoModel.menu3Options;
      });
    } else {
      // Si no hay datos en el provider, realizar las solicitudes para obtener los menús
      fetchMenuOptions();
    }
    if (isEnglish) {
      translations = {
        'CONFIRMAR': 'CONFIRMAR',
        //menu
        'VENTA DIRECTA': 'VENTA DIRECTA',
        'Cliente': 'Cliente',
        'Pedidos': 'Pedidos',
        'Cobranza': 'Cobranza',
        'Configuración': 'Configuración',
        'Actualización': 'Actualización',
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
        'Actualización': 'Update',
      };
    }
  }

  Future<void> fetchMenuOptions() async {
    try {
      // Realizar solicitud para el primer menú
      final response1 = await http.post(
        Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ10X1A_ORCH"),
        //Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ10X1A_ORCH'),
        headers: <String, String>{
          "Authorization": autorizacionGlobal,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username" : usuarioGlobal,
          "password" : contraGlobal
        }),
      );

      if (response1.statusCode == 200) {
        final data1 = json.decode(response1.body);
        setState(() {
          menu1Options = data1['MQ10X1A_FORMREQ_1'] as List<dynamic>;
        });
      } else {
        throw Exception('Failed to load data for Menu 1');
      }

      // Realizar solicitud para el segundo menú
      final response2 = await http.post(
        Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ10X3A_ORCH"),
       // Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ10X3A_ORCH'),
        headers: <String, String>{
          "Authorization": autorizacionGlobal,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username" : usuarioGlobal,
          "password" : contraGlobal
        }),
      );


      if (response2.statusCode == 200) {
        final data2 = json.decode(response2.body);
        setState(() {
          menu2Options = data2['MQ10X3A_DATAREQ'] as List<dynamic>;
        });
      } else {
        throw Exception('Failed to load data for Menu 2');
      }

      // Realizar solicitud para el tercer menú
      final response3 = await http.post(
        Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ10X4A_ORCH"),
       // Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ10X4A_ORCH'),
        headers: <String, String>{
          "Authorization": autorizacionGlobal,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username" : usuarioGlobal,
          "password" : contraGlobal
        }),
      );

      if (response3.statusCode == 200) {
        final data3 = json.decode(response3.body);
        setState(() {
          menu3Options = data3['MQ10X4A_DATAREQ']['rowset'] as List<dynamic>;

        });
      } else {
        throw Exception('Failed to load data for Menu 3');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              )
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 15), // Espaciado entre la primera fila y la segunda
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Text(
                              clienteGlobal,
                              style: TextStyle(
                                color: Color.fromRGBO(212, 20, 90, 1),
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              razonSocialGlobal,
                              style: TextStyle(
                                color: Color.fromRGBO(102, 45, 145, 1),
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            // SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),

                ),
                SizedBox(height: 5), // Espaciado entre la primera fila y la segunda
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(212, 20, 90, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    correoGlobal,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
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
        body:Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fondogris_solo.png'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              // Primer menú desplegable
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo blanco
                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                  border: Border.all(color: Colors.white), // Borde blanco
                ),
                margin: const EdgeInsets.only(bottom: 16.0), // Espaciado inferior
                child:
                DropdownButton<String>(
                  isExpanded: true, // Hace que el menú desplegable ocupe todo el ancho disponible
                  value: selectedOptionMenu1,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOptionMenu1 = newValue;
                      tipoPedidoGlobal= newValue.toString();
                    });
                  },
                  items: menu1Options?.map<DropdownMenuItem<String>>((dynamic option) {
                    return DropdownMenuItem<String>(
                      value: option['Codigo'] as String,
                      child: Text(option['Descripcion'] as String),
                    );
                  }).toList(),
                ),
              ),

              // Segundo menú desplegable
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo blanco
                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                  border: Border.all(color: Colors.white), // Borde blanco
                ),
                margin: const EdgeInsets.only(bottom: 16.0), // Espaciado inferior
                child:
                DropdownButton<String>(
                  isExpanded: true, // Hace que el menú desplegable ocupe todo el ancho disponible
                  value: selectedOptionMenu2,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOptionMenu2 = newValue;
                      depositoPedidoGlobal = newValue.toString();
                    });
                  },
                  items: menu2Options?.map<DropdownMenuItem<String>>((dynamic option) {
                    return DropdownMenuItem<String>(
                      value: option['Codigo'] as String,
                      child: Text(option['Codigo'] as String),
                    );
                  }).toList(),
                ),


              ),

              // Tercer menú desplegable
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo blanco
                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                  border: Border.all(color: Colors.white), // Borde blanco
                ),
                margin: const EdgeInsets.only(bottom: 16.0), // Espaciado inferior
                child:
                DropdownButton<String>(
                  isExpanded: true, // Hace que el menú desplegable ocupe todo el ancho disponible
                  value: selectedOptionMenu3,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOptionMenu3 = newValue;
                      monedaGlobal = newValue.toString();

                    });
                  },
                  items: menu3Options?.map<DropdownMenuItem<String>>((dynamic option) {
                    return DropdownMenuItem<String>(
                      value: option['Codigo'] as String,
                      child: Text(option['Codigo'] as String),
                    );
                  }).toList(),
                ),
              ),
              //const Spacer(), // Agregar un Spacer para empujar el botón hacia abajo
              SizedBox(height: 130),

              Align(
                alignment: Alignment.bottomCenter,
                child: MyElevatedButton(
                  onPressed: () async {
                    navigateToIncidenteScreen(context);
                    print(monedaGlobal+ depositoPedidoGlobal+ tipoPedidoGlobal);

                    // Acción al presionar el botón
                  },
                  child: Ink(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child:  Text(
                              translations['CONFIRMAR'] ?? '',
                              textAlign: TextAlign.center),
                        ),
                        if (loading) CircularProgressIndicator(), // Indicador de progreso (visible cuando loading es true)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),


      ),
    );
  }
}
void navigateToIncidenteScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PedidoNuevo2()));
}