import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Herramientas/boton.dart';
import '../Herramientas/global.dart';
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
  String correo = "";

  // Nuevo estado para controlar la visibilidad del indicador de progreso
  bool loading = false;

  final razonSocialController = TextEditingController();
  final cuitController = TextEditingController();

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

// Llama a esta función cuando se presiona el botón "BUSCAR"
  Future<void> buscarCliente() async {
    razonSocialController.text = "";
    cuitController.text = "";

    razonSocial = razonSocialController.text; // Actualiza razonSocial con el valor del controlador
    cuit = cuitController.text; // Actualiza cuit con el valor del controlador

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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Llama a mostrarOpcionesDeCliente aquí
        mostrarOpcionesDeCliente(data);

        setState(() {});
      } else {
        print("Error en la solicitud POST: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud POST: $e");
    }
  }

  //funcion para mostrar en el pop up
// Dentro de la función que muestra las opciones del cliente
  Future<void> mostrarOpcionesDeCliente(Map<String, dynamic> data) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Razón Social y CUIT"),
          content: Container(
            width: double.minPositive,
            child: ListView(
              children: data["MQ1002BD_DATAREQ"]["rowset"]
                  .map<Widget>((entry) {
                final razonSocial = entry["Razon_Social"].toString();
                final taxId = entry["Tax_ID"].toString();
                final cliente = entry["Cliente"].toString();
                final correo = entry["Correo"].toString();

                return ListTile(
                  title: Text(" $razonSocial, Tax_ID: $taxId"),
                  onTap: () {
                    setState(() {
                      razonSocialController.text = razonSocial;
                      cuitController.text = taxId; // Inserta el Tax ID seleccionado en el campo CUIT
                      // Actualiza las variables de "Cliente" y "Correo" aquí
                      this.cliente = cliente;
                      clienteGlobal = this.cliente;
                      this.correo = correo;
                      correoGlobal = this.correo;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void initState() {
    super.initState();
    if(razonSocialGlobal.isNotEmpty){
      razonSocialController.text= razonSocialGlobal;
      cuitController.text= clienteGlobal;
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
        body: SingleChildScrollView(
          child:Center(
            child : Container(
              constraints: BoxConstraints(
                maxWidth: double.infinity,
                minHeight: MediaQuery.of(context).size.height, // Ajusta la altura del Container al alto de la pantalla
              ),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/fondogris_solo.png'),
                  fit: BoxFit.cover, // Ajusta la imagen para cubrir completamente el Container
                ),
              ),
              //constraints: const BoxConstraints.expand(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'ALTA CLIENTE',
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
                                    controller: cuitController,
                                    decoration: InputDecoration(
                                      hintText: 'CUIT',
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
                            SizedBox(height: 16),
                            Center(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: 
                                Row(
                                  children: [
                                    Expanded(
                                        child:  TextField(
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
                                    IconButton(
                                      icon: Icon(Icons.arrow_drop_down),
                                      onPressed: buscarCliente,

                                    ),
                                  ],
                                ),

                              ),
                            ),
                           /* ElevatedButton(
                              onPressed: () {
                                // Guarda el valor en la variable global al presionar el botón de confirmación
                                setState(() {
                                  razonSocialGlobal = razonSocialController.text;
                                  clienteGlobal= this.cliente ;
                                  correoGlobal =this.correo ;

                                  if(correo.isEmpty){

                                  }
                                });
                              },
                              child: Icon(Icons.check, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green, // Color de fondo del botón de confirmación
                                shape: CircleBorder(), // Botón redondo
                              ),
                            ),*/
                            // Mostrar las sugerencias en una lista emergente debajo del TextField
                            if (suggestions.isNotEmpty)
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: suggestions
                                      .where((suggestion) => suggestion.toLowerCase().contains(razonSocialController.text.toLowerCase()))
                                      .toList()
                                      .map(
                                        (suggestion) => ListTile(
                                      title: Text(suggestion),
                                      onTap: () {
                                        setState(() {
                                          razonSocialController.text = suggestion;
                                          suggestions = [];
                                        });
                                      },
                                    ),
                                  )
                                      .toList(),

                              ),

                           )  ]
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 220),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Para centrar los botones horizontalmente
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Cliente: $razonSocialGlobal'),
                                  //   content: Text('La operación se realizó con éxito.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Aceptar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            // Guarda el valor en la variable global al presionar el botón de confirmación
                            setState(() {
                              razonSocialGlobal = razonSocialController.text;
                              clienteGlobal= cuitController.text ;
                              if(correoGlobal.isEmpty){
                                correoGlobal =this.correo ;
                              }
                            });

                          },
                          child: Text('     ACEPTAR    '),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Color.fromRGBO(212, 20, 90, 1.0); // Fondo rojo cuando está presionado
                                }
                                return Color.fromRGBO(212, 20, 90, 1.0); // Fondo rojo cuando está presionado
                              },
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Aplica un radio
                              ),
                            ),
                          ),                        ),
                        SizedBox(width: 16), // Espacio entre los botones
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/nuevoCliente");
                          },
                          child: Text('      NUEVO      ',
                            style: TextStyle(
                              color: Color.fromRGBO(212, 20, 90, 1.0), // Color del texto (blanco)
                            ),),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Color.fromRGBO(255, 255, 255, 1.0); // Fondo rojo cuando está presionado
                                }
                                return Color.fromRGBO(255, 255, 255, 1.0); // Fondo rojo cuando está presionado
                              },
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Aplica un radio
                                side: BorderSide(
                                  color: Color.fromRGBO(212, 20, 90, 1.0), // Color del texto (blanco)
                                  width: 1.0, // Grosor del borde
                                ),
                              ),
                            ),
                          ),                        ),
                      ],
                    ),
                  )
                  // Otro contenido aquí si es necesario
                ],
              ),
            ),
          ),
        ),
        ),
      );
  }
}
