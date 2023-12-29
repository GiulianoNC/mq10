import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mq10/Layouts/pedidos/pedidoNuevo_screen.dart';
import '../../Herramientas/global.dart';
import '../../Herramientas/variables_globales.dart';


class Pedidos extends StatefulWidget {


  const Pedidos({Key? key}) : super(key: key);

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  bool isLoading = false; // Variable para controlar el estado de carga
  int _selectedIndex = 0;
  //para seleccionar elementos
  Set<int> selectedItems = Set<int>();
  List<dynamic> items = [];
  var baseUrl = direc;

  //pedidos pendientes
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.post(
   Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ1008A_ORCH"),
       // Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ1008A_ORCH'),
      headers: <String, String>{
        "Authorization": autorizacionGlobal,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username" : usuarioGlobal,
        "password" : contraGlobal,
        //"Deposito": "11CAD",
        "Deposito": depositoGlobal,
        "Cliente": clienteGlobal,
        //"Cliente": "64979",
        "P4210_Version": "MQ10100",
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);




      final elements = data['MQ1008A_FORMREQ_1'] as List<dynamic>;
      items = elements;  // Asigna la lista de elementos directamente a la variable items
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  //menu
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
        //Navigator.pushNamed(context, "/pedidos");
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
    fetchData(); // Llama a fetchData solo una vez cuando el widget se inicia
    if (!isEnglish) {
      translations = {
        'Fecha de Orden': 'Fecha de Orden :',
        'Razon  Social': 'Razón  Social : ',
        'NRO_ORDEN': 'NRO_ORDEN : ',
        'NRO_LINEA': 'NRO_LINEA :',
        ' CANCELAR': 'CANCELAR',
        'NUEVO': 'NUEVO',
        //menu
        'VENTA DIRECTA': 'VENTA DIRECTA',
        'Cliente': 'Cliente',
        'Pedidos': 'Pedidos',
        'Cobranza': 'Cobranza',
        'Configuración': 'Configuración',
      };
    } else {
      translations = {
        'Fecha de Orden': 'Order Date : ',
        'Razon  Social': 'Company  Name :',
        'NRO_ORDEN': 'ORDER_NUMBER :',
        'NRO_LINEA': 'LINE_NUMBER : ',
        ' CANCELAR': 'CANCEL',
        'NUEVO': 'NEW',

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
              body: FutureBuilder<Map<String, dynamic>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final response = snapshot.data;
                    final items = response?['MQ1008A_FORMREQ_1'] as List<dynamic>;

                    if (items.isEmpty) {
                      return Center(child: Text('No hay elementos disponibles.'));
                    }
                    return CupertinoScrollbar(
                      child: Container(
                        height: 600, // Define una altura específica o usa un tamaño que se ajuste a tus necesidades
                        child: ListView.builder(
                          /*   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),*/
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index] as Map<String, dynamic>;
                            final isSelected = selectedItems.contains(index);
                            final isCanceled = item['canceled'] ?? false;

                            return Card(
                              color: isCanceled ? Colors.purple : (isSelected ? Colors.grey : Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromRGBO(102, 45, 145, 1.0),
                                        ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                              translations['Fecha de Orden'] ?? '',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:('${item['Fecha_Orden']}'),
                                            )
                                          ]
                                      )
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromRGBO(102, 45, 145, 1.0),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                              translations['Razon  Social'] ?? '',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:('${item['Razon_social']}'),
                                            )
                                          ]
                                      )
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromRGBO(102, 45, 145, 1.0),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                              translations['NRO_ORDEN'] ?? '',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:('${item['Orden_Nro']}'),
                                            )
                                          ]
                                      )
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromRGBO(102, 45, 145, 1.0),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                              translations['NRO_LINEA'] ?? '',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:('${item['Linea_Nro']}'),
                                            )
                                          ]
                                      )
                                  ),


                                /*  Text('Fecha de Orden: ${item['Fecha_Orden']}'),
                                  Text('Razón Social: ${item['Razon_social']}'),
                                  Text('NRO_ORDEN: ${item['Orden_Nro']}'),
                                  Text('NRO_LINEA: ${item['Linea_Nro']}'),*/
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value != null) {
                                          if (value) {
                                            selectedItems.add(index);
                                          } else {
                                            selectedItems.remove(index);
                                          }
                                        }
                                      });
                                    },
                                    activeColor: Colors.deepPurple,
                                    checkColor: Colors.white,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    );
                  }
                },
              ),      bottomSheet: BottomSheetButtons(
              items: items,
              selectedItems: selectedItems,
              setLoading: (bool value) {
                setState(() {
                  isLoading = value;
                });
                    },
              isLoading: isLoading, // Pasa isLoading al widget BottomSheetButtons
            ),

          ),

    );
  }
}

class BottomSheetButtons extends StatelessWidget {
  final List<dynamic> items;
  final Set<int> selectedItems;
  final void Function(bool value) setLoading; // Función para cambiar el estado de carga
  final bool isLoading; // Variable para controlar el estado de carga
  late Map<String, String> translations = {};


  BottomSheetButtons({
    required this.items,
    required this.selectedItems,
    required this.setLoading,
    required this.isLoading, // Agrega isLoading al constructor
  }){
    // Asigna las traducciones según el idioma
    if (!isEnglish) {
      translations = {
        'CANCELAR': 'CANCELAR',
        'NUEVO': 'NUEVO',
        'Confirmar Cancelación': 'Confirmar Cancelación',
        '¿Está seguro de cancelar los pedidos seleccionados?': '¿Está seguro de cancelar los pedidos seleccionados?',
        'SI': 'SI',
        'NO': 'NO',
      };
    } else {
      translations = {
        'CANCELAR': 'CANCEL',
        'NUEVO': '  NEW   ',
        'Confirmar Cancelación': 'Confirm Cancellation',
        '¿Está seguro de cancelar los pedidos seleccionados?': 'Are you sure about canceling selected orders?',
        'SI': 'YES',
        'NO': 'NO',
      };
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
                // Resto del código del botón "CANCELAR"
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        translations['Confirmar Cancelación'] ?? '',
                      ),
                      content: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                        translations['¿Está seguro de cancelar los pedidos seleccionados?'] ?? '',
                      ),
                      actions: <Widget>[
                        if (!isLoading)
                          TextButton(
                            child: Text('NO'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        TextButton(
                          child: Text(
                            translations['SI'] ?? '',
                          ),
                          onPressed: () async {
                            // Agrega este print para verificar selectedItems antes de la lógica de cancelación
                            print("selectedItems before cancellation: $selectedItems");

                            if (selectedItems.isNotEmpty) {
                              final selectedIndices = selectedItems.toList();
                              for (int index in selectedIndices.reversed) {
                                if (index >= 0 && index < items.length) {
                                  final selectedItem = items[index];
                                  final nroOrden = selectedItem['Orden_Nro'].toString();
                                  final nroLinea = selectedItem['Linea_Nro'].toString();

                                  // Realiza la solicitud POST para cancelar el pedido utilizando los valores nroOrden, deposito, nroLinea y p420Version
                                  // Agrega la lógica de la solicitud POST aquí

                                  final response = await http.post(
                                    Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ1009C_ORCH'),
                                    headers: <String, String>{
                                      "Authorization": autorizacionGlobal,
                                      'Content-Type': 'application/json',
                                    },
                                    body: jsonEncode({
                                      "username" : "sbasilico",
                                      "password" : "Silvio71",
                                      "Nro_Orden": nroOrden,
                                      "Deposito": "11CAD",
                                      "NRO_LINEA": nroLinea,
                                      "P4210_Version": "MQ10001"
                                    }),
                                  );

                                  if (response.statusCode == 200) {
                                    final data = json.decode(response.body);
                                    print("Respuesta completa: $data");

                                    // Actualiza la interfaz para desmarcar los checkboxes
                                    selectedItems.clear();

                                    setLoading(false); // Desactiva el estado de carga


                                    print("exito2");
                                    Navigator.of(context).pop();

                                    return data;
                                  } else {
                                    throw Exception('Failed to load data');
                                  }

                                  // Luego, actualiza la interfaz para reflejar la cancelación
                                  selectedItems.remove(index);
                                }
                              }
                            } else {
                              print("selectedItems is empty");
                            }

                            // Agrega este print para verificar selectedItems después de la lógica de cancelación
                            print("selectedItems after cancellation: $selectedItems");

                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
            child: Text(translations['CANCELAR'] ?? 'CANCELAR'), // Traducción para 'CANCELAR'
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
            ),

          ),
            ElevatedButton(
              onPressed: () {
                // Agrega aquí la lógica para el botón "NUEVO"
                navigateToIncidenteScreen(context);
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
              ),

            ),
          ],
        ),);
  }
}


void navigateToIncidenteScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PedidoNuevo()));
}