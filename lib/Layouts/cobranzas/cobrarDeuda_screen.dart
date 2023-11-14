import 'package:flutter/material.dart';
import 'package:mq10/Herramientas/variables_globales.dart';

import '../../Herramientas/global.dart';

class cobrarDeuda extends StatefulWidget {
  const cobrarDeuda({Key? key}) : super(key: key);

  @override
  State<cobrarDeuda> createState() => _cobrarDeudaState();
}

class _cobrarDeudaState extends State<cobrarDeuda> {
  int _selectedIndex = 0;
  var importeCobrar = totalDeudaGlobal;
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


  @override
  void initState() {
    super.initState();
    importeController = TextEditingController(text: totalDeudaGlobal);
    monedaController = TextEditingController(text: monedaGlobal);
    fechaController = TextEditingController();
    instrumendoPagoController = TextEditingController();
    bancoController = TextEditingController();
    numeroValorController = TextEditingController();
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
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 15), // Espaciado entre la primera fila y la segunda

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 60),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
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
                        ],
                      ),
                    ),
                  ],
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
                        buildTextField("IMPORTE \n A COBRAR ", "IMPORTE A COBRAR", importeController),
                        buildTextField("MONEDA          ", "MONEDA", monedaController),
                        buildTextField("FECHA           ", "FECHA", fechaController),
                        buildTextField("INSTRUMENTO \n DE PAGO           ", "INSTRUMENTO DE PAGO", instrumendoPagoController),
                        buildTextField("BANCO           ", "BANCO", bancoController),
                        buildTextField("NÚMERO\n VALOR           ", "NÚMERO VALOR", numeroValorController),

                      ],
                    ),
                  )
                ],
              )

            ],
          )
        ),
      ),
    );
  }
}
Widget buildTextField(String label, String hint, TextEditingController? controller) {
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
              // Puedes manejar el valor aquí
            },
          ),
        ),
      ],
    ),
  );
}
