import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mq10/Herramientas/variables_globales.dart';

import '../../Herramientas/global.dart';

class cobrarAnticipo extends StatefulWidget {
  const cobrarAnticipo({Key? key}) : super(key: key);

  @override
  State<cobrarAnticipo> createState() => _cobrarAnticipoState();
}

class _cobrarAnticipoState extends State<cobrarAnticipo> {
  int _selectedIndex = 0;
  var importeCobrar = totalDeudaGlobales;
  var  moneda = "";
  var fecha = "";
  var instrumendoPago = "";
  var banco ="";
  var numeroValor="";
  late TextEditingController importeController;
  late TextEditingController monedaController;
  late TextEditingController fechaController;
  late TextEditingController instrumendoPagoController;
  late TextEditingController bancoController;
  late TextEditingController numeroValorController;

  var baseUrl = direc;

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


  //pop up de instrumento de pago
  Future<List<String>> fetchInstrumentosDePago() async {
    final response = await http.post(
      Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ10X7A_ORCH"),

      //Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ10X7A_ORCH'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username" : usuarioGlobal,
        "password" : contraGlobal,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> instrumentos = data["MQ10X7A_FORMREQ_1"];
      print("esto es instrumentos$instrumentos");

      return instrumentos.map((e) => e["Descripcion"] as String).toList();
    } else {
      throw Exception('Failed to load instrumentos de pago');
    }
  }

  //pop up de banco
  Future<List<String>> fetchBancos() async {
    final response = await http.post(
      Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ10X6A_ORCH"),

      // Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ10X6A_ORCH'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username" : usuarioGlobal,
        "password" : contraGlobal,
      }),
    );


    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> bancos = data["MQ10X6A_FORMREQ_1"];
      print("esto es bancos$bancos");

      return bancos.map((e) => e["Descripcion"] as String).toList();
    } else {
      throw Exception('Failed to load bancos');
    }
  }

  Widget buildPopupDialog(BuildContext context, String title) {
    Future<List<String>> Function() fetchFunction;
    if (title == "Instrumento de Pago") {
      fetchFunction = fetchInstrumentosDePago;
    } else {
      fetchFunction = fetchBancos;
    }

    return AlertDialog(
      title: Text(title),
      content: FutureBuilder<List<String>>(
        future: fetchFunction(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                    onTap: () {
                      if (title == "Instrumento de Pago") {
                        instrumendoPagoController.text = snapshot.data![index];
                      } else {
                        bancoController.text = snapshot.data![index];
                      }
                      Navigator.of(context).pop();
                    },

                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    importeController = TextEditingController(text: totalDeudaGlobales);
    monedaController = TextEditingController(text: monedaGlobal);
    fechaController = TextEditingController(text: _getCurrentDate());
    instrumendoPagoController = TextEditingController();
    bancoController = TextEditingController();
    numeroValorController = TextEditingController();
  }

  //TENER LA FECHA ACTUAL E INSERTARLA
  String _getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = '${_formatDateValue(now.day)}-${_formatDateValue(now.month)}-${now.year}';
    return formattedDate;
  }

  String _formatDateValue(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  Widget buildDateField(String label, TextEditingController controller) {
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
              readOnly: true, // Hace que el campo de texto sea de solo lectura
              decoration: InputDecoration(
                hintText: 'Fecha',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Icon(Icons.calendar_today), // Icono para el calendario
              ),
              onTap: () async {
                // Opción para abrir un selector de fecha/calendario si se toca el campo
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null && pickedDate != DateTime.now()) {
                  setState(() {
                    // Formatea la fecha al formato deseado (dd/mm/aaaa)
                    String formattedDate =
                        '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year.toString()}';
                    // Actualiza el valor del controlador con la fecha formateada
                    controller.text = formattedDate;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
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
                )),
            child:ListView(
              children:<Widget> [
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextField("IMPORTE           \n A COBRAR ", "IMPORTE A COBRAR", importeController),
                          buildTextField("MONEDA            ", "MONEDA", monedaController),
                          buildDateField("FECHA                ", fechaController),
                          buildTextField("INSTRUMENTO \n DE PAGO           ",
                            "INSTRUMENTO DE PAGO",
                            instrumendoPagoController,
                                () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return buildPopupDialog(context, "Instrumento de Pago");
                                },
                              );
                            },
                          ),
                          buildTextField("BANCO               ",
                            "BANCO",
                            bancoController,
                                () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return buildPopupDialog(context, "Banco");
                                },
                              );
                            },
                          ),
                          //   buildTextField("INSTRUMENTO \n DE PAGO           ", "INSTRUMENTO DE PAGO", instrumendoPagoController),
                          //  buildTextField("BANCO           ", "BANCO", bancoController),
                          buildTextField("NÚMERO           \n VALOR           ", "NÚMERO VALOR", numeroValorController),

                        ],
                      ),
                    )
                  ],
                )

              ],
            )
        ),
        bottomSheet: Container(
          height: 60, // Define una altura específica o usa un tamaño que se ajuste a tus necesidades
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
                      onPressed: () async {
                        var url =  Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ1005C_ORCH");
                        //  var url = Uri.parse('http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ1005C_ORCH');

                        var requestBody = jsonEncode({
                          "username" : usuarioGlobal,
                          "password" : contraGlobal,
                          "Compania": companiaGlobal,
                          "Pagador": clienteGlobal,
                          "Moneda": monedaGlobal,
                          "Fecha": "12/10/2023",
                          //"Fecha": fechaController.text, // Obtener la fecha del controlador
                          "NroValor": numeroValorController.text,
                          "InstrumentoPago": "4",
                          //"InstrumentoPago": instrumendoPagoController.text,
                          "Importe_valor": importeController.text,
                          "Banco_valor": "999"
                          // "Banco_valor": bancoController.text,
                        });

                        var response = await http.post(
                          url,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: requestBody,
                        );

                        if (response.statusCode == 200) {
                          var jsonResponse = jsonDecode(response.body);
                          var nroRecibo = jsonResponse['NroRecibo'];
                          var jdeStatus = jsonResponse['jde__status'];

                          // Aquí puedes manejar la respuesta como desees, por ejemplo, mostrar un mensaje
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('APROBADO'),
                                  content: Text('NroRecibo: $nroRecibo, jde__status: $jdeStatus.'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          print('NroRecibo: $nroRecibo, jde__status: $jdeStatus');
                        } else {
                          // En caso de error en la solicitud
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('ERROR'),
                                  //   content: Text('NroRecibo: $nroRecibo, jde__status: $jdeStatus.'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          print('Request failed with status: ${response.statusCode}.');
                        }
                      },

                      child: Text(' CONFIRMAR',
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
                      ),                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para cobrar anticipo
                      },
                      child: Text('  CANCELAR',
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
                      ),                    ),
                  ),
                  SizedBox(width: 15), // Espaciado entre la primera fila y la segunda
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget buildTextField(String label, String hint, TextEditingController? controller, [VoidCallback? onTap]) {
  Color backgroundColor;
  Color textColor;
  bool readOnlyField = false;

  if (label == "IMPORTE           \n A COBRAR ") {
    backgroundColor = Color.fromRGBO(212, 20, 90, 1); // Fondo personalizado
    textColor = Colors.white; // Color de texto blanco
  } else if (label == "MONEDA            ") {
    backgroundColor = Color.fromRGBO(212, 20, 90, 1); // Fondo personalizado
    textColor = Colors.white; // Color de texto blanco
  } else {
    backgroundColor = Colors.white; // Fondo predeterminado
    textColor = Colors.black; // Color de texto predeterminado
  }

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
            onTap: onTap,
            readOnly: readOnlyField, // Hace que el campo de texto sea de solo lectura
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: backgroundColor,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: backgroundColor, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: onTap != null ? Icon(Icons.arrow_drop_down) : null,
            ),
            onChanged: (value) {
              // Handle value changes here
            },
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}


