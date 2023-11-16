import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mq10/Herramientas/variables_globales.dart';
import 'package:mq10/Layouts/cobranzas/cobrarDeuda_screen.dart';
import 'dart:convert';

import '../../Herramientas/global.dart';

class Cobranza extends StatefulWidget {
  const Cobranza({Key? key}) : super(key: key);

  @override
  State<Cobranza> createState() => _CobranzaState();
}

class _CobranzaState extends State<Cobranza> {
  int _selectedIndex = 3; // Inicializado para que se muestre Cobranza en el Drawer
  late Future<List<Map<String, dynamic>>> _futureData;
  List<bool> checkedStates = []; // Nuevo estado para almacenar el estado de los checkboxes

  bool containsMap(Map<String, dynamic> mapToCheck) {
    return selectedItems.any((item) =>
    item['Local_bruto'] == mapToCheck['Local_bruto'] &&
        item['Local_Pendiente'] == mapToCheck['Local_Pendiente']);
  }

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.post(
      Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ1006A_ORCH'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": "sbasilico",
        "password": "silvio71",
        "Cliente": "64979",
        "Moneda": "ARS",
        "Cia": "00028"
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> rowsetData = data['MQ1006A_DATAREQ']['rowset'].cast<Map<String, dynamic>>();
      print ("esta son los datos$rowsetData");

      return rowsetData;
    } else {
      throw Exception('Failed to load data');
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

  List<Map<String, dynamic>> selectedItems = []; // Mueve la definición de selectedItems al inicio de la clase
  List<Map<String, dynamic>> data = []; // Agregar este para almacenar los datos recibidos


  // Método para manejar los cambios en los CheckBoxes
// Actualiza la función updateSelectedItem
  void updateSelectedItem(int index, bool selected) {
    final selectedLocalBruto = data[index]['Local_bruto'];
    final selectedLocalPendiente = data[index]['Local_Pendiente'];

    setState(() {
      final currentMap = {
        'Local_bruto': selectedLocalBruto,
        'Local_Pendiente': selectedLocalPendiente,
      };

      if (selected) {
        if (!containsMap(currentMap)) {
          selectedItems.add(currentMap);
          totalDeudaGlobal = selectedLocalBruto.toString();
          print("deuda es : "+totalDeudaGlobal);
        }
      } else {
        selectedItems.removeWhere((item) =>
        item['Local_bruto'] == selectedLocalBruto &&
            item['Local_Pendiente'] == selectedLocalPendiente);
        // Resto de tu lógica
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        borderRadius: BorderRadius.circular(8),
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
              //  SizedBox(height: 5), // Espaciado entre la primera fila y la segunda
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(212, 20, 90, 1),
                  borderRadius: BorderRadius.circular(8),
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
          Container(
            decoration:BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/fondogris_solo.png'),
                  fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el contenedor
                ),
          ),
      child:
      FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            data = snapshot.data ?? []; // Almacena los datos recibidos

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            //CONDICION PARA EL FONDO DEPENDIENDO DE LO QUE DÉ Doc_tipo
                            backgroundColor: snapshot.data![index]['Doc_Tipo'] == 'FA'
                            //si es igual a FA
                                ? Color.fromRGBO(102, 45, 145, 1.0)
                            //SI ES DISTINTO A FA
                                : Color.fromRGBO(212, 20, 90, 1.0),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${snapshot.data![index]['Doc_Tipo']}',
                            ),
                            TextSpan(
                              text: ' ${snapshot.data![index]['Comprobante']}',
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(102, 45, 145, 1.0),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'CÓDIGO: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${snapshot.data![index]['Doc_Numero']}',
                              //style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(102, 45, 145, 1.0),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'TOTAL: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${snapshot.data![index]['Local_bruto']}',
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(102, 45, 145, 1.0),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'PENDIENTE: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${snapshot.data![index]['Local_Pendiente']}',
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(102, 45, 145, 1.0),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'TOTAL FORANEO: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${snapshot.data![index]['Foraneo_Bruto']}',
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(102, 45, 145, 1.0),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'PENDIENTE FORANEO: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${snapshot.data![index]['Foraneo_Pendiente']}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing:
                  Checkbox(
                    value: containsMap({
                      'Local_bruto': snapshot.data![index]['Local_bruto'],
                      'Local_Pendiente': snapshot.data![index]['Local_Pendiente'],
                    }),
                    onChanged: (bool? value) {
                      setState(() {
                        updateSelectedItem(index, value ?? false);
                      });
                    },
                    activeColor: Colors.grey,
                    checkColor: Colors.blue,
                  ),                );
              },
            );
          }
        },
      ),
    ),
      bottomSheet: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/cobrarDeuda");
                    },
                    child: Text(' COBRAR DEUDA'),
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
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/cobrarAnticipo");

                    },
                    child: Text(' COBRAR ANTICIPO',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

