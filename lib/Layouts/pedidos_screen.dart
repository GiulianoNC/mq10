import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import '../Herramientas/variables_globales.dart';
import 'pedidoNuevo_screen.dart';


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

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.post(
      Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ1008A_ORCH'),
      headers: <String, String>{
        "Authorization": autorizacionGlobal,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": "sbasilico",
        "password": "Silvio71",
        "Deposito": "11CAD",
        "Cliente": "64979",
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
  void initState() {
    super.initState();
    fetchData(); // Llama a fetchData solo una vez cuando el widget se inicia
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          ScaffoldMessenger(
            child:      Scaffold(
              // key: _scaffoldKey,  // Elimina esta línea
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
              body:
              FutureBuilder<Map<String, dynamic>>(
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
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: items.length,  // Usa la lista de elementos a nivel de clase
                        itemBuilder: (context, index) {
                          final item = items[index] as Map<String, dynamic>;
                          final isSelected = selectedItems.contains(index);
                          final isCanceled = item['canceled'] ?? false;

                          return Card(
                            color: isCanceled ? Colors.purple : (isSelected ? Colors.grey : Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Fecha de Orden: ${item['Fecha_Orden']}'),
                                Text('Razón Social: ${item['Razon_social']}'),
                                Text('NRO_ORDEN: ${item['Orden_Nro']}'), // Muestra NRO_ORDEN en lugar de Fecha de Orden
                                //  Text('DEPOSITO: ${item['Deposito']}'), // Muestra DEPOSITO en lugar de Razón Social
                                Text('NRO_LINEA: ${item['Linea_Nro']}'),
                                //  Text('P4210_Version: ${item['P4210_Version']}'),

                                Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      print('Checkbox at index $index was clicked. New value: $value');
                                      if (value != null) {
                                        if (value) {
                                          selectedItems.add(index);
                                        } else {
                                          selectedItems.remove(index);
                                        }
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
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
    ));
  }
}
class BottomSheetButtons extends StatelessWidget {
  final List<dynamic> items;
  final Set<int> selectedItems;
  final void Function(bool value) setLoading; // Función para cambiar el estado de carga
  final bool isLoading; // Variable para controlar el estado de carga

  BottomSheetButtons({
    required this.items,
    required this.selectedItems,
    required this.setLoading,
    required this.isLoading, // Agrega isLoading al constructor
  });
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
                      title: Text('Confirmar Cancelación'),
                      content: isLoading
                          ? CircularProgressIndicator()
                          : Text('¿Está seguro de cancelar los pedidos seleccionados?'),
                      actions: <Widget>[
                        if (!isLoading)
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        TextButton(
                          child: Text('Aceptar'),
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
              child: Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () {
                // Agrega aquí la lógica para el botón "NUEVO"
                navigateToIncidenteScreen(context);
              },
              child: Text('NUEVO'),
            ),
          ],
        ),);

  }
}

void navigateToIncidenteScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PedidoNuevo()));
}