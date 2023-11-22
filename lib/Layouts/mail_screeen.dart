import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mq10/Herramientas/global.dart';

import '../Herramientas/boton.dart';
import '../Herramientas/variables_globales.dart';

class mail extends StatefulWidget {
  const mail({Key? key}) : super(key: key);

  @override
  State<mail> createState() => _mailState();
}

class _mailState extends State<mail> {
  int _selectedIndex = 0;
  String selectedMail = ""; // Variable para almacenar el valor seleccionado del menú desplegable
  bool loading = false; // Nuevo estado para controlar la visibilidad del indicador de progreso
  List<String> mailOptions = [""]; // Lista para almacenar las opciones del menú desplegable
  var baseUrl = direc;

  @override
  void initState() {
    super.initState();
    // Cargar las opciones del menú desplegable desde el servicio web aquí
    loadMailOptions();
    print("esto son los datos "+correoGlobal+razonSocialGlobal +clienteGlobal);
  }
  // Realizar una solicitud HTTP al servicio web y obtener las opciones de correo
  Future<void> loadMailOptions() async {

    final response = await http.post(Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ1002B_ORCH"),
      headers: <String, String>{
        "Authorization": autorizacionGlobal,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username" : usuarioGlobal,
        "password" : contraGlobal,
        "Cliente": "",
        "Correo":""
      }
      ),
    );


    if (response.statusCode == 200) {
       final data = json.decode(response.body);
       //print(data);
       final mailData = data['MQ1002BD_DATAREQ']['rowset'] as List<dynamic>;
       final mailOptions = mailData
           .map((mail) => mail['Correo'] as String)
           .where((correo) => correo.trim().isNotEmpty) // Filtra las direcciones de correo no vacías
           .toSet()// Usamos toSet() para eliminar duplicados

           .toList();
       setState(() {
         this.mailOptions = mailOptions;
         if (mailOptions.isNotEmpty) {
           selectedMail = mailOptions[0]; // Establece el primer elemento como valor predeterminado
         }
       });
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
    // Agrega la lógica para navegar a las pantallas correspondientes aca
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
        body: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fondogris_solo.png'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                  child: DropdownButton<String>(
                    value: selectedMail,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMail = newValue ?? ''; // Actualiza selectedMail con el nuevo valor seleccionado
                      });
                    },
                    items: mailOptions.toSet().map((String mailOption) {
                      return DropdownMenuItem<String>(
                        value: mailOption,
                        child: Text(mailOption),
                      );
                    }).toList(),
                  )
              ),
              const Spacer(), // Agregar un Spacer para empujar el botón hacia abajo
              Align(
                alignment: Alignment.bottomCenter,
                child: MyElevatedButton(
                  onPressed: () async {
                    // Acción al presionar el botón
                  },
                  child: Ink(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: const Text('CONFIRMAR', textAlign: TextAlign.center),
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
