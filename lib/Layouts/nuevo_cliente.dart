import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Herramientas/boton.dart';
import '../Herramientas/variables_globales.dart';

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

  List<Map<String, String>> estados = []; // Lista de estados desde la solicitud POST

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
//lista desplegable
  Future<void> cargarEstados() async {
    final url = Uri.parse("http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ10X5A_ORCH");
    final headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers);
      final data = json.decode(response.body);
      print(data);

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
  Future<void> buscarCliente() async {
    // Validación de campos obligatorios
    if (cuit.isEmpty || razonSocial.isEmpty) {
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
      return;
    }

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

  Widget buildDropdown(String label, List<Map<String, String>> items, String selectedValue) {
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
  }

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Cierra el menú lateral
    // Agrega la lógica para navegar a las pantallas correspondientes aquí
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/login");
        break;
      case 1:
        Navigator.pushNamed(context, "/congrats");
        break;
      case 2:
        Navigator.pushNamed(context, "/correctivo");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    cargarEstados();
    estadoValue = estados.isNotEmpty ? estados[0]["Estado"] : null;

  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> estadosDropdownItems = estados.map((estado) {
      return DropdownMenuItem<String>(
        value: estado["Estado"],
        child: Text(estado["Estado"]!),
      );
    }).toList();
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
                        '\nQTM - MANTENIMIENTO\n          CORRECTIVO\n\n',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
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
                  selected: _selectedIndex == 0,
                  onTap: () {
                    _onMenuItemSelected(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.checklist),
                  title: Text('Cliente',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),),
                  selected: _selectedIndex == 1,
                  onTap: () {
                    _onMenuItemSelected(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.library_add_check_rounded),
                  title: Text('Nuevo Correctivo',
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
                Center(
                  child: Text(
                    'IDENTIFICADOR CLIENTE',
                    style: TextStyle(
                      color: Color.fromRGBO(102, 45, 145, 30),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextField("CUIT           ", "CUIT", cuit),
                          buildTextField("RAZÓN       \nSOCIAL", "RAZÓN SOCIAL", razonSocial),
                          buildTextField("DIRECCIÓN", "DIRECCIÓN", direccion),
                          buildDropdown("ESTADO", estados, selectedEstado),
                          buildTextField("CÓDIGO      \nPOSTAL", "CÓDIGO POSTAL", codigoPostal),
                          buildTextField("TÉLEFONO \nPÉFIJO", "TÉLEFONO PÉFIJO", telefonoPrefijo),
                          buildTextField("TÉLEFONO \nNÚMERO", "TÉLEFONO NÚMERO", telefonoNumero),
                          buildTextField("MAIL           ", "CORREO", correo),
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
                        onPressed: buscarCliente,
                        child: Text('CONFIRMAR'),
                      ),
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
Widget buildTextField(String label, String hint, String value) {
  return Container(
    margin: EdgeInsets.only(bottom: 10), // Espacio entre los TextField
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
            decoration: InputDecoration(
              hintText: hint,
              filled: true, // Rellena el fondo del TextField
              fillColor: Colors.white, // Fondo blanco
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0), // Bordes blancos
                borderRadius: BorderRadius.circular(10.0), // Radio de los bordes
              ),
            ),
            onChanged: (value) {
              // Puedes manejar el valor aquí
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
