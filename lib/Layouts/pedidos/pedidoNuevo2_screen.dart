import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Herramientas/boton.dart';
import '../../Herramientas/global.dart';
import '../../Herramientas/variables_globales.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class PedidoNuevo2 extends StatefulWidget {
  const PedidoNuevo2({Key? key}) : super(key: key);

  @override
  State<PedidoNuevo2> createState() => _PedidoNuevo2State();
}

class _PedidoNuevo2State extends State<PedidoNuevo2> {
  int _selectedIndex = 0;
  TextEditingController _codigoController = TextEditingController();
  TextEditingController _cantidadController = TextEditingController();
  String _dropdownValue = 'Selecciona una opción'; // Valor predeterminado
  List<Map<String, String>> listaPedido = [];

  // Lista para almacenar los índices de elementos seleccionados
  List<int> selectedIndices = [];

  Future<void> _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color de fondo del botón de escaneo
      'Cancelar', // Texto del botón de cancelar
      false, // Modo de escaneo continuo
      ScanMode.BARCODE, // Tipo de código de barras para escanear (puedes ajustarlo según tus necesidades)
    );

    setState(() {
      // Aquí puedes manejar el resultado del escaneo, por ejemplo, asignarlo al campo de texto
      _codigoController.text = barcodeScanRes;
    });
  }


  // Función para mostrar la ventana emergente con la información del pedido
  Future<void> _mostrarInfoPedido(Map<String, String> pedido) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
         // title: Text('Información del Pedido'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(212, 20, 90, 1),
                  ),
                  children: [
                    TextSpan(
                      text: 'CÓDIGO: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: '${pedido['CÓDIGO']}'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(212, 20, 90, 1),
                  ),
                  children: [
                    TextSpan(
                      text: 'PRODUCTO: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: '${pedido['PRODUCTO']}'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(212, 20, 90, 1),
                  ),
                  children: [
                    TextSpan(
                      text: 'CANTIDAD: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: '${pedido['CANTIDAD']}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CONFIRMAR'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCELAR'),
            ),
          ],
        );
      },
    );
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

  //busca producto y lo pone en un menudesplegable
  Future<List<String>> fetchDropdownItems() async {
    final url = Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ10X2A_ORCH');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": "sbasilico",
        "password": "Silvio71",
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('MQ10X2A_DATAREQ')) {
        final items = data['MQ10X2A_DATAREQ'] as List<dynamic>;
        final descriptions = items.map((item) => item['Descripcion'] as String).toList();
        // Establecer _dropdownValue en el primer elemento si la lista no está vacía
        if (descriptions.contains(_dropdownValue)) {
          // Si está contenido, déjalo como está
        } else if (descriptions.isNotEmpty) {
          // Si no está contenido y la lista no está vacía, establece el valor predeterminado en el primer elemento
          _dropdownValue = descriptions[0];
        }


        return descriptions;
      } else {
        throw Exception('No data found');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

//boton que agrega lo que se inserte en los campos
  Future<void> _continuar() async {
    String codigo = _codigoController.text;
    String producto = _dropdownValue;
    String cantidad = _cantidadController.text;

    try {
      if (codigo.isNotEmpty && producto.isNotEmpty && cantidad.isNotEmpty) {
        // Agrega los datos a la lista
        listaPedido.add({
          'CÓDIGO': codigo,
          'PRODUCTO': producto,
          'CANTIDAD': cantidad,
        });

        // Limpia los controladores
        _codigoController.clear();
        _cantidadController.clear();

        // Puedes imprimir la lista para verificar que se están almacenando correctamente
        print(listaPedido);
      } else {
        // Código para manejar campos vacíos
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Por favor, completa todos los campos antes de continuar.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Excepción al agregar a la lista: $e');
      // Aquí puedes agregar lógica para manejar la excepción, como mostrar un diálogo de error.
    }
  }


  // Método para eliminar elementos seleccionados
  void _eliminarElementosSeleccionados() {
    // Eliminar elementos de listaPedido basado en selectedIndices
    List<int> reversedIndices = selectedIndices.toList()..sort((a, b) => b.compareTo(a));
    for (var index in reversedIndices) {
      listaPedido.removeAt(index);
    }
    // Limpiar lista de elementos seleccionados
    selectedIndices.clear();
  }

  // Método para realizar el POST request
  void _realizarPostRequest() async {
    // Construir la lista de objetos para el body
    List<Map<String, String>> grilla = listaPedido
        .map((pedido) => {
      "Cantidad_solicitada": pedido['CANTIDAD'] ?? '', // Ajustar a tu estructura de datos
      "Número_artículo": pedido['CÓDIGO'] ?? '', // Ajustar a tu estructura de datos
    })
        .toList();

    // Realizar el POST request
    final url = Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ1009A_ORCH');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": "sbasilico",
        "password": "Silvio71",
        "Deposito": "11CAD",
        "Cliente": "64979",
        "Moneda": "ARS",
        "Grilla": grilla,
        "P4210_Version": "MQ10001"
      }),
    );

    if (response.statusCode == 200) {
      print("ok");
      // Manejar la respuesta exitosa aquí
    } else {
      // Manejar errores
      print("NO");
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

              ],
            ),
          ),
        ),
          body:
          Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/fondogris_solo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              constraints: const BoxConstraints.expand(),
              child:          SingleChildScrollView(
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(102, 45, 145, 1.0),
                          ),
                          children: [
                            TextSpan(
                              text: 'TIPO DE PEDIDO: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '${tipoPedidoGlobal}'),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(102, 45, 145, 1.0),
                          ),
                          children: [
                            TextSpan(
                              text: 'DEPOSITO: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '${depositoGlobal}'),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(102, 45, 145, 1.0),
                          ),
                          children: [
                            TextSpan(
                              text: 'MONEDA: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '${monedaGlobal}'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Espacio entre las variables y los campos siguientes

                 // Campo de escaneo con icono de cámara
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Fondo blanco
                        borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                        border: Border.all(color: Colors.white), // Borde blanco
                      ),
                      margin: const EdgeInsets.only(bottom: 16.0), // Espaciado inferior
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _codigoController ,
                              decoration: InputDecoration(
                                labelText: 'CÓDIGO',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: _scanBarcode,
                          ),
                        ],
                      ),
                    ),
                    // Campo desplegable con un Post request
                    Container(
                      width: double.infinity, // Ancho igual al ancho del dispositivo
                      decoration: BoxDecoration(
                        color: Colors.white, // Fondo blanco
                        borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                        border: Border.all(color: Colors.white), // Borde blanco
                      ),
                      margin: const EdgeInsets.only(bottom: 16.0), // Espaciado inferior
                      child:
                      FutureBuilder<List<String>>(
                        future: fetchDropdownItems(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return
                              DropdownButton<String>(
                                value: _dropdownValue, // Asocia el valor seleccionado al controlador
                                isExpanded: true, // Expande el DropdownButton para ocupar el ancho completo
                                underline: SizedBox(), // Elimina la línea de abajo del DropdownButton
                                icon: Icon(Icons.arrow_drop_down), // Agrega un ícono personalizado de flecha hacia abajo
                                items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  // Handle dropdown value change
                                  setState(() {

                                    _dropdownValue = newValue ?? ''; // Actualiza el valor seleccionado
                                  });
                                },
                              );
                          } else {
                            return Text('No data available');
                          }
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Fondo blanco
                        borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                        border: Border.all(color: Colors.white), // Borde blanco
                      ),
                      margin: const EdgeInsets.only(bottom: 16.0), // Espaciado inferior
                      child:
                      // Campo numérico
                      TextField(
                        controller: _cantidadController  ,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'CANTIDAD',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 4), // Espacio entre los campos y el botón de "Continuar"
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para continuar
                        _continuar();
                        setState(() {}); // Redibuja la interfaz después de agregar elementos a listaPedido
                      },
                      child: Text('  Continuar  '),
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
                    // Lista de pedidos
                Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child :SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Lista desplazable de pedidos
                              Container(
                                //height: 200, // Define una altura específica o usa un tamaño que se ajuste a tus necesidades
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: listaPedido.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 80,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: selectedIndices.contains(index),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                if (value != null && value) {
                                                  selectedIndices.add(index);
                                                } else {
                                                  selectedIndices.remove(index);
                                                }
                                              });
                                            },
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromRGBO(102, 45, 145, 1),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'CÓDIGO: ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '${listaPedido[index]['CÓDIGO']}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromRGBO(102, 45, 145, 1),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'PRODUCTO: ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '${listaPedido[index]['PRODUCTO']}',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromRGBO(102, 45, 145, 1),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'CANTIDAD: ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '${listaPedido[index]['CANTIDAD']}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                              ),
                            ],
                          ),
                        ),
                      ),


                    ElevatedButton(
                      onPressed: selectedIndices.isNotEmpty
                          ? () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmar acción'),
                              content: Text('¿Qué acción deseas realizar?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _realizarPostRequest();
                                    Navigator.of(context).pop();
                                    setState(() {}); // Redibuja la interfaz después de enviar elementos a listaPedido

                                  },
                                  child: Text('Enviar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Modificar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _eliminarElementosSeleccionados();
                                    Navigator.of(context).pop();
                                    setState(() {}); // Redibuja la interfaz después de eliminar elementos a listaPedido
                                  },
                                  child: Text('Eliminar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                          : null,
                      child: Text('      SELECCIONAR      ',
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
                )

            )

          )

      ),
    );
  }
}

