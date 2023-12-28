import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Herramientas/boton.dart';
import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';
import 'actualizacion.dart';

class ClienteNuevo extends StatefulWidget {
  const ClienteNuevo({Key? key}) : super(key: key);

  @override
  State<ClienteNuevo> createState() => _ClienteNuevoState();
}

class _ClienteNuevoState extends State<ClienteNuevo> {
  var _selectedIndex = 0;
  var razonSocial = "";
  var cuit = "";
  var cliente = "";
  var  direccion = "";
  var estado = "";
  var codigoPostal = "";
  var telefonoPrefijo ="";
  var telefonoNumero="";
  var correo = "";
  var _selectedEstado; // Estado seleccionado

  final cuitController = TextEditingController();
  final razonSocialController = TextEditingController();
  final direccionController = TextEditingController();
  final codigoPostalController = TextEditingController();
  final telefonoPrefijoController = TextEditingController();
  final telefonoNumeroController = TextEditingController();
  final correoController = TextEditingController();
  var baseUrl = direc;

  // Lista de estados
  List<Map<String, String>> _estados = [];


  List<Map<String, String>> estados = []; // Lista de estados desde la solicitud POST


  void _mostrarListaEstados() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona un estado'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: estados.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(estados[index]["Estado"] ?? ""),
                  onTap: () {
                    setState(() {
                      _selectedEstado = estados[index]["Estado"];
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildDropdown(EstadoModel estadoModel) {
    return estadoModel.estadosNombres.isNotEmpty
        ? Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            'ESTADO     ',
            style: TextStyle(
              color: Color.fromRGBO(102, 45, 145, 30),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedEstado ?? estadoModel.estadosNombres[0],
              items: estadoModel.estadosNombres.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEstado = newValue; // Actualiza el estado seleccionado
                });
              },
            ),
          ),
        ],
      ),
    )
        : Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            'ESTADO     ',
            style: TextStyle(
              color: Color.fromRGBO(102, 45, 145, 30),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: TextEditingController(text: _selectedEstado ?? ''),
              decoration: InputDecoration(
                hintText: 'Selecciona un estado',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    // Lógica para mostrar la lista de estados
                    // Puedes llamar a un método para mostrar la lista aquí
                  },
                  icon: Icon(Icons.arrow_drop_down),
                ),
              ),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }


  //campo de estado
  Widget buildEstadoDropdown() {
    return  Container(
      margin: EdgeInsets.only(bottom: 10), // Espacio entre los TextField
      child: Row(
        children: [
          Text(
            'ESTADO     ',
            style: TextStyle(
              color: Color.fromRGBO(102, 45, 145, 30),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: TextEditingController(text: _selectedEstado ?? ''),
              decoration: InputDecoration(
                hintText: 'Selecciona un estado',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  onPressed: _mostrarListaEstados, // Función para mostrar la lista de estados
                  icon: Icon(Icons.arrow_drop_down), // Icono de flecha hacia abajo
                ),
              ),
              readOnly: true,
            ),
          ),
        ],
      )
    );
  }

  // Estado seleccionado
  String? estadoValue;

  // Variable para almacenar el valor seleccionado del estado
  String selectedEstado = "";

  // Método para actualizar el estado seleccionado
  void updateSelectedEstado(String newValue) {
    setState(() {
      selectedEstado = newValue;
    });
  }

//lista desplegable
  Future<void> cargarEstados() async {

    late var api = "/jderest/v3/orchestrator/MQ10X5A_ORCH";

    var url = Uri.parse(baseUrl + api);
    final headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers);
      final data = json.decode(response.body);
     // print(data);

      if (data.containsKey("MQ10X5A_FORMREQ_1")) {
        final estadosData = data["MQ10X5A_FORMREQ_1"];
        List<Map<String, String>> estadosList = [];
        for (var estadoData in estadosData) {
          estadosList.add({
            "Codigo": estadoData["Codigo"],
            "Estado": estadoData["Estado"],
          });
        }

        // Antes de asignar a la lista estados, elimina duplicados utilizando un Set
        estadosList = estadosList.toSet().toList();

        setState(() {
          estados = estadosList;
          estadoValue = estados.isNotEmpty ? estados[0]["Estado"] : null;
          selectedEstado = estadoValue ?? "";
        });
      } else {
        print("No se encontraron estados en la respuesta.");
      }
    } catch (e) {
      print("Error en la solicitud POST: $e");
    }
  }

  //cargar nuevo cliente y se valida los datos obligatorios
  Future<void> generarCliente() async {
    // Validación de campos obligatorios
    var cuitValue = cuitController.text; // Reemplaza cuitController con el controlador correcto
    var razonSocialValue = razonSocialController.text; // Reemplaza razonSocialController con el controlador correcto
    late var api = "/jderest/v3/orchestrator/MQ1002B_ORCH";

    print(cuitValue + razonSocialValue);

  /*  if (cuitValue.length==0 || razonSocialValue.length == 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Campos obligatorios vacíos'),
            content: Text('Por favor, complete los campos CUIT y Razón Social.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      //return;
    }else{

    }*/


    var url = Uri.parse(baseUrl + api);
    final body = jsonEncode({
      "username" :usuarioGlobal,
      "password" : contraGlobal,
      "Razon_Social": razonSocial,
      "Tax_ID": cuit,
      "Direccion1": direccion,
      "Estado": estado,
      "Codig_Postal": codigoPostal,
      "Zona_Venta": "741",
      "Tipo_NroLegal": "080",
      "Clase_Contable": "NAC",
      "Explicacion_Fiscal": "V",
      "Area_Fiscal": "ARIVA21",
      "Busqueda": "C",
      "Correo" : correo,
      "Telefono_Prefijo": telefonoPrefijo,
      "Telefono_Numero": telefonoNumero,
      "InstruccionEntrega1": "Preguntar por Adrian",
      "InstruccionEntrega2": "Despues del mediodia",
      "Programa_Ajuste": "PCR"
    });

    final headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, body: body, headers: headers);
      final data = json.decode(response.body);
      //AGREGAR A GLOBALES
      razonSocialGlobal = razonSocialController.text;
      clienteGlobal = cuitController.text;
      correoGlobal = correoController.text;

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('CLIENTE AGREGADO'),
              //   content: Text('La operación se realizó con éxito.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.pushNamed(context, "/congrats");
                    //Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        setState(() {});
      } else {
        print("Error en la solicitud POST: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud POST: $e");
    }
  }

 /* Widget buildDropdown(String label, List<Map<String, String>> items, String selectedValue) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromRGBO(102, 45, 145, 30),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: DropdownButton<String>(
            value: selectedValue,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item["Estado"],
                child: Text(item["Estado"]!),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedEstado = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }*/

  late Map<String, String> translations = {};
  @override
  void initState() {
    super.initState();
    // Acceder al modelo de estado
    final estadoModel = Provider.of<EstadoModel>(context, listen: false);

    // Verificar si hay datos en estadosNombres
    if (estadoModel.estadosNombres.isEmpty) {
      print("esta vacio");
      // Si no hay datos, llamar a cargarEstados desde actualización layout
      cargarEstados();
    }else{
      print("estadosNombres: ${estadoModel.estadosNombres}");
      //  print("selectedEstado: ${estadoModel.selectedEstado}");
    }
    if (isEnglish) {
      translations = {
        'Razon  Social': 'RAZÓN       \nSOCIAL',
        'DIRECCION': 'DIRECCION',
        'ESTADO': 'ESTADO',
        'CODIGO POSTAL': 'CODIGO\n POSTAL',
        'TELEFONO FIJO': 'TELEFONO\n FIJO',
        'TELEFONO NUMERO': 'TELEFONO\n NUMERO',
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
        'Razon  Social': 'COMPANY \nNAME ',
        'DIRECCION': 'ADRESS     ',
        'ESTADO': 'STATE',
        'CODIGO POSTAL': 'ZIP CODE   ',
        'TELEFONO FIJO': 'LANDLINE  \nPHONE',
        'TELEFONO NUMERO': '   PHONE    \n NUMBER',
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

 /* @override
  void initState() {
    super.initState();
    cargarEstados();
    estadoValue = estados.isNotEmpty ? estados[0]["Estado"] : null;
  }*/

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
        body: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fondogris_solo.png'),
              fit: BoxFit.cover,
            )),
            child: ListView(
              children:<Widget> [
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextField("CUIT           ", "CUIT", cuitController ),
                          buildTextField( translations['Razon  Social'] ?? '',
                              translations['Razon  Social'] ?? '', razonSocialController ),
                          buildTextField(translations['DIRECCION'] ?? '',
                              translations['DIRECCION'] ?? '', direccionController ),
                          buildEstadoDropdown(), // Campo de texto para el estado
                          buildTextField(translations['CODIGO POSTAL'] ?? '',
                              translations['CODIGO POSTAL'] ?? '',codigoPostalController ),
                          buildTextField(translations['TELEFONO FIJO'] ?? '',
                              translations['TELEFONO FIJO'] ?? '', telefonoPrefijoController ),
                          buildTextField(translations['TELEFONO NUMERO'] ?? '',
                              translations['TELEFONO NUMERO'] ?? '', telefonoNumeroController ),
                          buildTextField("MAIL            ",
                              "MAIL", correoController ),
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 15), // Espacio de 15 píxeles entre los botones
                    Expanded(
                      child: MyElevatedButton(
                        onPressed: generarCliente,
                        child: Text(
                          translations['CONFIRMAR'] ?? '',
                        ), ),
                    ),
                  ],
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

//campos configuracion
Widget buildTextField(String label, String hint, TextEditingController controller) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromRGBO(102, 45, 145, 30),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {
              // Puedes manejar el valor aquí si es necesario
            },
          ),
        ),
      ],
    ),
  );
}

class CustomDropdownDialog<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T value;
  final ValueChanged<T?> onChanged;

  CustomDropdownDialog({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  _CustomDropdownDialogState<T> createState() => _CustomDropdownDialogState<T>();
}

class _CustomDropdownDialogState<T> extends State<CustomDropdownDialog<T>> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.items.map((item) {
          return ListTile(
            title: item.child,
            onTap: () {
              widget.onChanged(item.value);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }
}
