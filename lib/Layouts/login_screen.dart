import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import 'package:flutter/widgets.dart';

import '../Herramientas/boton.dart';
import '../Herramientas/global.dart'as global;
import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  var login = '';
  var password = '';
  var direccion = '';
  var emisor = '';
  var estados = '';

  var compania = '';
  var moneda = '';
  var est1 = '';
  var zona = '';
  var banco = '';
  var instrumento = '';
  var deposito = '';
  var est6 = '';


  var value ="";
  var value2 ="";
  var value3 ="";
  var value4 ="";
  var value5 ="";
  var value6 ="";
  var value7 ="";
  var value8 ="";
  var value9 ="";
  var value10 ="";
  var value11 ="";


  bool _isChecked = false;

  // Variables booleanas para rastrear si los campos obligatorios son válidos
  bool isUrlValid = true;
  bool isCompaniaValid = true;
  bool isMonedaValid = true;

  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();
  final myController5 = TextEditingController();
  final myController6 = TextEditingController();
  final myController7 = TextEditingController();
  final myController8 = TextEditingController();
  final myController9 = TextEditingController();
  final myController10 = TextEditingController();
  final myController11 = TextEditingController();
  Icon icon = Icon (Icons.visibility);
  bool obscure = true;
  bool loading = false; // Nuevo estado para controlar la visibilidad del indicador de progreso

  final controller = PageController();

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fondogris_solo.png'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: PageView(
            controller: controller,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      alignment: Alignment.center,
                      child: Image.asset("images/logo.png"),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: TextField(
                        controller: myController,
                        style: const TextStyle(color: Colors.black,),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Usuario',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          login = value;
                          global.user = value;
                        },
                      ),
                    ),
                    //constraseña
                    Container(
                      padding: const EdgeInsets.symmetric
                        (
                          vertical: 10.0, horizontal: 20.0),
                      child: TextField(
                        obscureText: obscure,
                        controller: myController2,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration:  InputDecoration(
                          suffixIcon: IconButton (
                              color:  Colors.deepPurple,
                              onPressed: () {
                                setState ( () {
                                  if (obscure == true) {
                                    obscure = false;
                                    icon = Icon (Icons.visibility_off, color: Colors.red,);
                                  } else {
                                    obscure = true;
                                    icon = Icon (Icons.visibility, color: Colors.deepPurple,);
                                  }
                                });
                              },
                              icon: icon
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Contraseña',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          password = value;
                          global.pass = value;
                        },
                      ),
                    ),
                    //Checkbox
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 90.0),
                      child: CheckboxListTile(
                        //cambia de lugar poniendo primero el check y despues el texto
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text('RECORDAR',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(102, 45, 145, 30),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                          ),),
                        value: _isChecked,
                        activeColor: Color.fromRGBO(102, 45, 145, 30),
                        checkColor: Colors.white,
                        onChanged: (bool? value0) {
                          if (value0 != null) {
                            _saveData(value0);
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          //distancia margen
                          width: 22,
                        ),
                        Expanded(
                            child:Ink(
                              child:   MyElevatedButton(
                                onPressed: ()  async {
                                  setState(() {
                                    loading = true; // Muestra el indicador de progreso al hacer clic
                                  });

                                  try{
                                    //yo
                                    if (direccion.isEmpty){
                                      direccion = value3;
                                      global.direc = value3;

                                    }
                                    if (emisor.isEmpty){
                                      emisor = value4;
                                      global.emisor = value4;
                                    }
                                    if(login.isEmpty){
                                      login = value;
                                      usuarioGlobal = value;
                                      global.user = value;
                                    }
                                    if(password.isEmpty){
                                      password = value2;
                                      contraGlobal= value2;
                                      global.pass = value2;
                                    }
                                    if(moneda.isNotEmpty){
                                      monedaGlobal = myController5.text;
                                    }
                                    if(deposito.isNotEmpty){
                                      depositoGlobal = myController11.text;
                                    }

                                    print("la moneda es : $monedaGlobal");
                                    print("ldeposito es : $depositoGlobal");

                                    estadoAprobacionG = value5;
                                    estado = value5;
                                    print (value3 + value2+ value5);

                                    var baseUrl =  direccion;
                                    direc= direccion;
                                    late var api = "/jderest/v3/orchestrator/MQ10X1A_ORCH";
                                    //   Future<dynamic> post(String api, dynamic object) async {
                                    var url = Uri.parse(baseUrl + api);
                                    print("direcion $url");

                                    var _payload = json.encode({
                                      "username":usuarioGlobal,
                                      "password": contraGlobal,
                                    });

                                    //transformo el usuario y contraseña en base 64
                                    autorizacionGlobal = 'Basic '+base64Encode(utf8.encode('$login:$password'));
                                    print(autorizacionGlobal );
                                    Navigator.pushNamed(context, "/congrats");

                                    var _headers = {
                                      "Authorization" : autorizacionGlobal,
                                      'Content-Type': 'application/json',
                                    };

                                    var response = await http.post(url, body: _payload, headers: _headers).timeout(Duration(seconds: 60));
                                    print("este es el status " + response.statusCode.toString());
                                    if (response.statusCode == 200) {

                                      // guardar_datos("login","password","direccion","moneda");

                                      Navigator.pushNamed(context, "/congrats");

                                      print("este es el status " + response.statusCode.toString());


                                    } else {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                          title: const Text('ERROR'),
                                          content: const Text('Inicio de sesión o contraseña incorrectos'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'Vuelve a intentarlo'),
                                              child: const Text('Inténtalo de nuevo'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }catch(e){
                                    // Manejar errores
                                    print('Error: $e');
                                  }finally{
                                    // Asegúrate de restablecer loading a false después de completar la tarea, ya sea exitosa o con errores.
                                    setState(() {
                                      loading = false;
                                    });
                                  }

                                },
                                child: Ink(
                                    decoration: BoxDecoration(
                                      // gradient: LinearGradient(colors: [Colors.red, Colors.green]),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children:[
                                        Container(
                                          // padding: const EdgeInsets.all(10),
                                          //  constraints: const BoxConstraints(minWidth: 88.0),
                                          child: const Text('INGRESAR', textAlign: TextAlign.center),
                                        ),
                                        if (loading)
                                          CircularProgressIndicator(), // Indicador de progreso (visible cuando loading es true)
                                      ],)
                                ),
                              ),
                            )
                        ),
                        SizedBox(
                          //distancia margen
                          width: 22,
                        ),
                      ],
                    ),

                  ]
              ),
              SingleChildScrollView(
                child : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                          alignment: Alignment.center,
                          child: Image.asset("images/logo.png"),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                          //URL
                          child: TextField(
                            controller: myController3,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration:  InputDecoration(
                              filled: true,
                              fillColor: isUrlValid ? Colors.white : Colors.red, // Mostrar en rojo si no es válido
                              hintText: 'URL/HTTP',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              direccion = value;
                              global.direc = value;
                              setState(() {
                                isUrlValid = true; // Restablecer la validez al editar
                              });
                            },
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                            child: TextField(
                              controller: myController4,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration:  InputDecoration(
                                filled: true,
                                fillColor: isCompaniaValid ? Colors.white : Colors.red, // Mostrar en rojo si no es válido
                                hintText: 'COMPAÑIA',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                value=  value.toUpperCase() ;
                                compania = value;
                                global.companiaGlobal = value;
                                setState(() {
                                  isCompaniaValid = true; // Restablecer la validez al editar
                                });
                              },
                            )
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                            child: TextField(
                              controller: myController5,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration:  InputDecoration(
                                filled: true,
                                fillColor: isMonedaValid ? Colors.white : Colors.red, // Mostrar en rojo si no es válido
                                hintText: 'MONEDA',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                value=  value.toUpperCase() ;
                                moneda = value;
                                global.estadoAprobacionG= value;
                                setState(() {
                                  isMonedaValid = true; // Restablecer la validez al editar
                                });
                              },
                            )
                        ),
                        SizedBox(
                          //distancia margen
                          height: 12,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                            child: TextField(
                              controller: myController6,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'ESTADO',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                value=  value.toUpperCase() ;
                                est1 = value;
                                global.esta1G = value;
                              },
                            )
                        ),
                        Row(
                          children: [
                            Expanded(
                                child:   Container(
                                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                                    child: TextField(
                                      controller: myController7,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'ZONA',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        value=  value.toUpperCase() ;
                                        zona = value;
                                        global.esta2G = value;
                                      },
                                    )
                                ) ),
                          ],
                        ),
                        SizedBox(
                          //distancia margen
                          height: 12,
                        ),
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                            child: TextField(
                              controller: myController8,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'BANCO',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                value=  value.toUpperCase() ;
                                banco = value;
                                global.esta3G = value;
                              },
                            )
                        ),
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                            child: TextField(
                              controller: myController10,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'INSTRUMENTO',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                value=  value.toUpperCase() ;
                                instrumento = value;
                                global.esta5G = value;
                              },
                            )
                        ),
                        SizedBox(
                          //distancia margen
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child:Container(
                                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                                    child: TextField(
                                      controller: myController11,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'DEPOSITO',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        value=  value.toUpperCase() ;
                                        deposito = value;
                                        global.depositoGlobal = value;
                                      },
                                    )
                                ) ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                          child:   MyElevatedButton(
                            onPressed: ()  async {
                              // Verificar si los campos obligatorios están llenos
                              if (direccion.isEmpty) {
                                setState(() {
                                  isUrlValid = false;
                                });
                              }
                              if (compania.isEmpty) {
                                setState(() {
                                  isCompaniaValid = false;
                                });
                              }
                              if (moneda.isEmpty) {
                                setState(() {
                                  isMonedaValid = false;
                                });
                              }

                              // Si todos los campos obligatorios son válidos, regresar a la página uno
                             /* if (isUrlValid && isCompaniaValid && isMonedaValid) {
                                Navigator.pop(context);
                              }*/
                            },
                            child: Ink(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children:[
                                    Container(
                                       padding: const EdgeInsets.all(10),
                                      //  constraints: const BoxConstraints(minWidth: 88.0),
                                      child: const Text('CONFIRMAR', textAlign: TextAlign.center),
                                    ),
                                    if (loading)
                                      CircularProgressIndicator(), // Indicador de progreso (visible cuando loading es true)
                                  ],)
                            ),
                          ),
                        )

                      ]
                  ),
                ),
              ),

            ],
          )
      ),
      bottomSheet:
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.grey, Colors.grey]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: Icon(Icons.account_box,
                color: Color.fromRGBO(102, 45, 145, 30),
              ),
              onPressed: (){
                controller.jumpToPage(0);
              }, label: Text(""),

            ),
            Center(
                child: SmoothPageIndicator(
                  controller : controller,
                  count: 2,
                  effect: WormEffect(
                      spacing: 16,
                      dotColor: Colors.black26,
                      activeDotColor: Colors.deepPurple
                  ),
                  onDotClicked: (index){
                    controller.animateToPage(index, duration: const Duration(microseconds: 500),
                        curve: Curves.easeIn);
                  },
                )
            ),
            TextButton.icon(
              icon: Icon(Icons.settings,
                color: Color.fromRGBO(102, 45, 145, 30),
              ),
              onPressed: (){
                controller.jumpToPage(2);
              },
              label: Text(""),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void>  _saveData(bool value0) async{
    value = login;
    value2=password;
    value3=direccion;
    value4=emisor;
    value5 = estados;



    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("TestString_key", value);
    prefs.setString("TestString_key2", value2);
    prefs.setString("TestString_key3", value3);
    prefs.setString("TestString_key4", value4);
    prefs.setString("TestString_key5", value5);




    setState(() {
      _isChecked = value0;
      prefs.setBool('isChecked', value0);
    });


  }
  Future<void> _cargarPreferencias() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    value = prefs.getString("TestString_key")!;
    value2 = prefs.getString("TestString_key2")!;
    value3 = prefs.getString("TestString_key3")!;
    value4 = prefs.getString("TestString_key4")!;
    value5 = prefs.getString("TestString_key5")!;


    print(value + value2 +value3 +value4);

    myController.text = value;
    myController2.text = value2;
    myController3.text = value3;
    myController4.text = value4;
    myController5.text = value5;



    setState(() {
      _isChecked = (prefs.getBool('isChecked') ?? false);
    });
  }

}





















