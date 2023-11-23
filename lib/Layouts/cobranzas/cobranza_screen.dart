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
  late List<bool> checkedStates;
  List<Map<String, dynamic>> selectedItems = []; // Lista de elementos seleccionados
  Key _listKey = GlobalKey(); // Agrega una Key para el ListView
  Set<int> selectedItem = Set<int>();//para seleccionar elementos
  bool mostrarLocal = true;

  var baseUrl = direc;


  // Método para verificar si un elemento está en la lista de seleccionados
  bool containsMap(Map<String, dynamic> mapToCheck) {
    return selectedItems.any((item) =>
    item['Local_bruto'] == mapToCheck['Local_bruto'] &&
        item['Local_Pendiente'] == mapToCheck['Local_Pendiente']);
  }
  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
    print(monedaGlobal);
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.post(
      Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ1006A_ORCH"),
      //Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ1006A_ORCH'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username" : usuarioGlobal,
        "password" : contraGlobal,
        "Cliente":clienteGlobal,
        "Moneda": monedaGlobal,
        "Cia": companiaGlobal,
      }),
    );
    print(usuarioGlobal+contraGlobal);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> rowsetData = data['MQ1006A_DATAREQ']['rowset'].cast<Map<String, dynamic>>();

      return rowsetData.map((map) {
        final String monedaRespuesta = map['Moneda'] ?? '';

        final bool mostrarLocal = monedaGlobal == monedaRespuesta;

        final filteredData = mostrarLocal
            ? {
          'Local_bruto': map['Local_bruto'],
          'Local_Pendiente': map['Local_Pendiente'],
        }
            : {
          'Foraneo_Bruto': map['Foraneo_Bruto'],
          'Foraneo_Pendiente': map['Foraneo_Pendiente'],
        };

        return {
          'Comprobante': map['Comprobante'] ?? '',
          'Doc_Tipo': map['Doc_Tipo'] ?? '',
          'Doc_Numero': map['Doc_Numero'] ?? '',
          ...filteredData,
        };
      }).toList();
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

 // List<Map<String, dynamic>> selectedItems = []; // Mueve la definición de selectedItems al inicio de la clase
  List<Map<String, dynamic>> data = []; // Agregar este para almacenar los datos recibidos


  // Método para manejar los cambios en los CheckBoxes
  int totalDeudaGlobal = 0;
// Actualiza la función updateSelectedItem
  void updateSelectedItem(int index, bool selected) {
    final selectedLocalPendiente = data[index]['Local_Pendiente'];
    final int parsedLocalPendiente = selectedLocalPendiente;

    setState(() {
      if (selected) {
        selectedItem.add(index);
        totalDeudaGlobal += parsedLocalPendiente;
        totalDeudaGlobales = totalDeudaGlobal.toString();
        print("Total deuda global: $totalDeudaGlobal");
      } else {
        selectedItem.remove(index);
        totalDeudaGlobal -= parsedLocalPendiente;
        totalDeudaGlobales = totalDeudaGlobal.toString();
        print("Total deuda global: $totalDeudaGlobal");
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
      Padding(
        padding: EdgeInsets.only(bottom: 90.0), // Ajusta este valor según necesites más o menos espacio para el BottomSheet
        child:      Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Expanded(
                child: Container(
                  decoration:BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/fondogris_solo.png'),
                      fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el contenedor
                    ),
                  ),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futureData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        data = snapshot.data ?? []; // Almacena los datos recibidos
                        checkedStates = List<bool>.filled(data.length, false); // Inicializa los estados de los checkboxes


                        return ListView.builder(
                          key: _listKey, // Asigna la Key al ListView
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final isSelected = selectedItem.contains(index);

                            return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child:  ListTile(
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
                                              text: mostrarLocal ? ' ' : 'TOTAL FORANEO: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: mostrarLocal
                                                  ? '${snapshot.data![index]['Local_bruto']}'
                                                  : '${snapshot.data![index]['Foraneo_Bruto']}',
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
                                              text: mostrarLocal ? ' ' : 'PENDIENTE FORANEO: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: mostrarLocal
                                                  ? '${snapshot.data![index]['Local_Pendiente']}'
                                                  : '${snapshot.data![index]['Foraneo_Pendiente']}',
                                            ),
                                          ],
                                        ),
                                      ),
                                /*      RichText(
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
                                      ),*/
                                    ],
                                  ),
                                  trailing:
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value != null) {
                                          updateSelectedItem(index, value); // Asegúrate de llamar a updateSelectedItem aquí
                                          print('Checkbox value changed: $value'); // Agrega este print statement

                                          if (value) {
                                            selectedItem.add(index);
                                          } else {
                                            selectedItem.remove(index);
                                          }
                                        }
                                      });
                                    },
                                    activeColor: Colors.deepPurple,
                                    checkColor: Colors.white,
                                  )
                               /*   Checkbox(
                                    value: checkedStates[index], // Asigna el valor de checkedStates al checkbox
                                    onChanged: (bool? value) {
                                      setState(() {
                                        checkedStates[index] = value ?? false;
                                        print('Checked state at index $index: ${checkedStates[index]}'); // Agrega este print statement
                                        updateSelectedItem(index, value ?? false); // Agrega esta línea para actualizar los elementos seleccionados

                                      });
                                      setState(() {
                                        _listKey = GlobalKey(); // Crea una nueva instancia de la Key

                                      });
                                    },
                                    activeColor: Colors.black,
                                    checkColor: Colors.blue,
                                  ),*/

                                )

                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              )
            ]
        ),
      ),
      bottomSheet: Container(
        height: 60, // Define una altura específica o usa un tamaño que se ajuste a tus necesidades
        color: Colors.white,
        //padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 15), // Espaciado entre la primera fila y la segunda
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/cobrarDeuda");
                    },
                    child: Text(' COBRAR DEUDA',
                      style: TextStyle(
                        fontSize: 12,
                      ),),
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
                SizedBox(width: 15), // Espaciado entre la primera fila y la segunda
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/cobrarAnticipo");

                    },
                    child: Text(' COBRAR ANTICIPO',
                      style: TextStyle(
                        color: Color.fromRGBO(212, 20, 90, 1.0), // Color del texto (blanco)
                        fontSize: 12,
                      ),

                    ),
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
                SizedBox(width: 15), // Espaciado entre la primera fila y la segunda

              ],
            ),
          ],
        ),
      ),
    );
  }
}

