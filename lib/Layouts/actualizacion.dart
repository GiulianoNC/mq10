import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';

class actualizacion extends StatefulWidget {
  const actualizacion({Key? key}) : super(key: key);

  @override
  State<actualizacion> createState() => _actualizacionState();
}
// Crear una clase para manejar los datos cargados


class _actualizacionState extends State<actualizacion> {
  static  late List<Map<String, dynamic>> rowData = []; // Variable para almacenar los datos
  static  List<String> estadosNombres = []; // Lista para guardar los nombres de los estados
  bool isLoading = true; // Estado de carga cliente
  bool isLoadingEstados = true; // Estado de carga estados
  bool isLoadingPedidos = true; // Estado de carga cliente

  bool dataLoaded = false; // Si los datos han sido cargados
  bool dataLoadedEstados = false; // Si los estados han sido cargados
  var baseUrl = direc;
  static bool areEstadosLoaded = false; // Flag para saber si los estados están cargados
  static List<String> estados = [];

  Future<void> cargarDatosCliente() async {
    setState(() {
      isLoading = true; // Mostrar el indicador de carga
      dataLoaded = true;
    });

    late var api = "/jderest/v3/orchestrator/MQ1002B_ORCH";

    var url = Uri.parse(baseUrl + api);
    final body = jsonEncode({
      "RAZON_SOCIAL": "MA",
      "TAX_ID": ""
    });
    final headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, body: body, headers: headers);


      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey("MQ1002BD_DATAREQ") && data["MQ1002BD_DATAREQ"].containsKey("rowset")) {
          final nuevosClientes = List<Map<String, dynamic>>.from(data["MQ1002BD_DATAREQ"]["rowset"]);
          setState(() {
            // Actualiza el modelo de datos de clientes utilizando Provider
            Provider.of<ClienteModel>(context, listen: false).actualizarClientes(nuevosClientes);
            print(nuevosClientes.runtimeType);

            rowData = List<Map<String, dynamic>>.from(data["MQ1002BD_DATAREQ"]["rowset"]);
            isLoading = false; // Datos cargados
            dataLoaded = true; // Marcar que los datos han sido cargados
          });
        }
      } else {
        print('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> cargarEstados() async {
    setState(() {
      isLoadingEstados = true;
    });

    late var api = "/jderest/v3/orchestrator/MQ10X5A_ORCH";

    var url = Uri.parse(baseUrl + api);
    final body = jsonEncode({
      "username" :usuarioGlobal,
      "password" : contraGlobal,
    });

    final headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(url, body: body, headers: headers);


      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey("MQ10X5A_FORMREQ_1")) {
          final List<dynamic> estadosData = data["MQ10X5A_FORMREQ_1"];
          List<Map<String, String>> estadosList = [];

          for (var estadoData in estadosData) {
            estadosList.add({
              "Estado": estadoData["Estado"],
            });
          }

          // Eliminar duplicados utilizando un Set
          estadosList = estadosList.toSet().toList();

          setState(() {
            // Aquí se extraen solo los nombres de estado y se almacenan en estadosNombres
            estadosNombres = estadosList.map((e) => e['Estado'] ?? '').toList();
            // estados = estadosList; // Se mantiene la lista de mapas para otros usos si es necesario
            isLoadingEstados = false;
            dataLoadedEstados = true;
            // Después de cargar los estados, actualiza el modelo utilizando Provider
            Provider.of<EstadoModel>(context, listen: false).actualizarEstados(estadosNombres);

          });
        } else {
          print("No se encontraron estados en la respuesta.");
        }
      } else {
        print('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  int completedRequests = 0;

  Future<void> fetchMenuOptions() async {
    setState(() {
      isLoadingEstados = true; // Mostrar el indicador de carga
    });
    try {
      // Realizar solicitud para el primer menú
      final response1 = await http.post(
        Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ10X1A_ORCH"),
        headers: <String, String>{
          "Authorization": autorizacionGlobal,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": usuarioGlobal,
          "password": contraGlobal,
        }),
      );

      if (response1.statusCode == 200) {
        final data1 = json.decode(response1.body);
        Provider.of<PedidoModel>(context, listen: false)
            .actualizarOpcionesMenu1(data1['MQ10X1A_FORMREQ_1'] as List<dynamic>);
        print('datosss');
        completedRequests++;


      } else {
        throw Exception('Failed to load data for Menu 1');
      }

      // Realizar solicitud para el segundo menú
      final response2 = await http.post(
        Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ10X3A_ORCH"),
        headers: <String, String>{
          "Authorization": autorizacionGlobal,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": usuarioGlobal,
          "password": contraGlobal,
        }),
      );

      if (response2.statusCode == 200) {
        final data2 = json.decode(response2.body);
        Provider.of<PedidoModel>(context, listen: false)
            .actualizarOpcionesMenu2(data2['MQ10X3A_DATAREQ'] as List<dynamic>);
        print('datosss');
        completedRequests++;

      } else {
        throw Exception('Failed to load data for Menu 2');
      }

      // Realizar solicitud para el tercer menú
      final response3 = await http.post(
        Uri.parse(baseUrl + "/jderest/v3/orchestrator/MQ10X4A_ORCH"),
        headers: <String, String>{
          "Authorization": autorizacionGlobal,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": usuarioGlobal,
          "password": contraGlobal,
        }),
      );

      if (response3.statusCode == 200) {
        final data3 = json.decode(response3.body);
        Provider.of<PedidoModel>(context, listen: false)
            .actualizarOpcionesMenu3(data3['MQ10X4A_DATAREQ']['rowset'] as List<dynamic>);
        completedRequests++;

        if (completedRequests == 3) {
          setState(() {
            isLoadingPedidos = false;
          });
        }
      } else {
        throw Exception('Failed to load data for Menu 3');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    cargarDatosCliente(); // Llamar a la función para obtener los datos al iniciar la pantalla
    cargarEstados(); // Llamar a cargarEstados al inicio
    fetchMenuOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? CircularProgressIndicator()
                : Icon(
              dataLoaded ? Icons.check : Icons.circle,
              size: 40,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text('Clientes'),
            SizedBox(height: 20),
            isLoadingEstados
                ? CircularProgressIndicator()
                : Icon(
              dataLoadedEstados ? Icons.check : Icons.circle,
              size: 40,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text('Estados'),
            isLoadingPedidos
                ? CircularProgressIndicator()
                : Icon(
              dataLoadedEstados ? Icons.check : Icons.circle,
              size: 40,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text('Pedidos'),
          ],
        ),
      ),
    );
  }
}

class EstadoModel with ChangeNotifier {
  List<String> estadosNombres = [];

  void actualizarEstados(List<String> nuevosEstados) {
    estadosNombres = nuevosEstados;
    notifyListeners(); // Notificar a los oyentes que los datos han sido actualizados
  }
}

class ClienteModel with ChangeNotifier {
  List<Map<String, dynamic>> clientesData = [];

  void actualizarClientes(List<Map<String, dynamic>> nuevosClientes) {
    clientesData = nuevosClientes;
    notifyListeners(); // Notificar a los oyentes que los datos han sido actualizados
  }
}

class PedidoModel with ChangeNotifier {
  List<dynamic>? menu1Options;
  List<dynamic>? menu2Options;
  List<dynamic>? menu3Options;

  void actualizarOpcionesMenu1(List<dynamic> opciones) {
    menu1Options = opciones;
    notifyListeners();
  }

  void actualizarOpcionesMenu2(List<dynamic> opciones) {
    menu2Options = opciones;
    notifyListeners();
  }

  void actualizarOpcionesMenu3(List<dynamic> opciones) {
    menu3Options = opciones;
    notifyListeners();
  }
}




