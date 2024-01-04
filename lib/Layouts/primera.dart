import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Herramientas/boton.dart';
import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';
import 'actualizacion.dart';

class Primera extends StatefulWidget {

  const Primera({Key? key}) : super(key: key);

  @override
  State<Primera> createState() => _PrimeraState();
}


class _PrimeraState extends State<Primera> {
  int _selectedIndex = 0;
  var razonSocial = "";
  var cuit = "";
  var cliente = "";
  var correo = "";
  var baseUrl = direc;

  // Nuevo estado para controlar la visibilidad del indicador de progreso
  bool loading = false;

  final razonSocialController = TextEditingController();
  final cuitController = TextEditingController();

  // Define una variable para controlar la visibilidad del campo CUIT
  bool mostrarCampoCUIT = false;

  List<String> suggestions = [];

  // Función para buscar sugerencias de RAZON SOCIAL
  Future<void> buscarSugerencias(String query) async {

    late var api = "/jderest/v3/orchestrator/MQ1002B_ORCH";

    final url = Uri.parse(baseUrl + api);
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

  Future<void> buscarSugerenciasPorTaxID(String query) async {
    late var api = "/jderest/v3/orchestrator/MQ1002B_ORCH";

    final url = Uri.parse(baseUrl + api);
    final body = jsonEncode({
      "RAZON_SOCIAL": "",
      "TAX_ID": query,
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
            .map<String>((entry) => entry["TAX_ID"].toString())
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
      case 5:
        Navigator.pushNamed(context, "/actualizacion");
        break;
    }
  }

// Llama a esta función cuando se presiona la flechita desplegable
  Future<void> buscarCliente() async {
    razonSocialController.text = "";
    cuitController.text = "";
    late var api = "/jderest/v3/orchestrator/MQ1002B_ORCH";
    razonSocial = razonSocialController.text; // Actualiza razonSocial con el valor del controlador
    cuit = cuitController.text; // Actualiza cuit con el valor del controlador

    var url = Uri.parse(baseUrl + api);
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
    List<Map<String, dynamic>> opciones = List<Map<String, dynamic>>.from(
        data["MQ1002BD_DATAREQ"]["rowset"]
    );

    await showDialog(
      context: context,
      builder: (context) {
        List<Map<String, dynamic>> filtradas = List<Map<String, dynamic>>.from(opciones);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                translations['Razon Social y CUIT'] ?? '',
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText:
                      translations['BUSCAR'] ?? '',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filtradas = opciones.where((option) {
                          final razonSocial = option["Razon_Social"].toString().toLowerCase();
                          final taxId = option["Tax_ID"].toString().toLowerCase();
                          final searchValue = value.toLowerCase();
                          return razonSocial.contains(searchValue) || taxId.contains(searchValue);
                        }).toList();
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtradas.length,
                      itemBuilder: (BuildContext context, int index) {
                        final entry = filtradas[index];
                        final razonSocial = entry["Razon_Social"].toString();
                        final taxId = entry["Tax_ID"].toString();
                        final cliente = entry["Cliente"].toString();
                        final correo = entry["Correo"].toString();

                        return ListTile(
                          title: Text(" $razonSocial, Tax_ID: $taxId"),
                          onTap: () {
                            setState(() {
                              razonSocialController.text = razonSocial;
                              cuitController.text = taxId;
                              clienteGlobal = cliente;
                              correoGlobal = correo;
                              mostrarCampoCUIT = true;

                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  late Map<String, String> translations = {};

  void initState() {
    super.initState();
    if(razonSocialGlobal.isNotEmpty){
      razonSocialController.text= razonSocialGlobal;
      cuitController.text= clienteGlobal;
      mostrarCampoCUIT = true;
    }
    final clienteProvider = Provider.of<ClienteModel>(context, listen: false);

    if (clienteProvider.clientesData.isEmpty) {
      // No hay datos en el Provider, busca los datos del cliente
      buscarCliente();
    } else {
      // Utiliza los datos del Provider
      final data = clienteProvider.clientesData;
      // Realiza la operación que necesites con los datos existentes
      //mostrarOpcionesDeCliente(data);
      print("hay datos$data");
    }
    if (!isEnglish) {
      translations = {
        'ALTA CLIENTE': 'ALTA CLIENTE',
        'Razon  Social': 'Razon  Social',
        'ACEPTAR': 'ACEPTAR',
        'NUEVO': 'NUEVO',
        'BUSCAR': 'BUSCAR',
        'Razon Social y CUIT': 'Razon Social y CUIT',
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
        'ALTA CLIENTE': 'Customer Registration',
        'Razon  Social': 'Company  Name',
        'ACEPTAR': 'ACEPT',
        'NUEVO': 'NEW',
       ' BUSCAR': 'SEARCH',
         'Razon Social y CUIT': 'Company Name and CUIT',

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
                ListTile(
                  leading: Icon(Icons.download_done,
                    color: Colors.grey, // Cambia el color del icono
                  ),
                  title: Text(
                    translations['Actualización'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  selected: _selectedIndex == 5,
                  onTap: () {
                    _onMenuItemSelected(5);
                  },
                ),

              ],
            ),
          ),
        ),
        body:
        Container(
          constraints: BoxConstraints(
            maxWidth: double.infinity,
            minHeight: MediaQuery.of(context).size.height, // Ajusta la altura del Container al alto de la pantalla
          ),
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fondogris_solo.png'),
              fit: BoxFit.fill, // Ajusta la imagen para cubrir completamente el Container
            ),
          ),
          //constraints: const BoxConstraints.expand(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  translations['ALTA CLIENTE'] ?? '',
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
                                            hintText: translations?['Razon  Social'] ?? '',
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
                                    ).toList(),
                                  ),
                                )  ]
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15), // Espacio entre los campos
              Visibility(
                visible: mostrarCampoCUIT,
                child:  Column(
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
              ),
              SizedBox(height: 120),
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
                                  child: Text(
                                    translations['ACEPTAR'] ?? '',
                                  ),
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
                          cuitGlobal= cuitController.text ;
                          if(correoGlobal.isEmpty){
                            correoGlobal =this.correo ;
                          }
                        });

                      },
                      child: Text(
                        translations['ACEPTAR'] ?? '',
                      ),
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
                      child: Text(
                        translations['NUEVO'] ?? '',
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
    );
  }
}


