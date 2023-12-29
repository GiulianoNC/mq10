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
  final myController11 = TextEditingController();//obsoleto
  bool _isChecked = false;

  Icon icon = Icon (Icons.visibility);
  bool obscure = true;
  bool loading = false; // Nuevo estado para controlar la visibilidad del indicador de progreso

  final controller = PageController();

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
    _loadSavedData();
  }
  @override
  void disponse(){
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    myController5.dispose();
    myController6.dispose();
    myController7.dispose();
    myController8.dispose();
    myController9.dispose();
    myController10.dispose();

    super.dispose();
  }

  Future<void> _saveData(bool value) async {
    setState(() {
      isChecked = value;
    });

    String loginValue = myController.text;
    String passwordValue = myController2.text;
    String direccionValue = myController3.text;
    String companiaValue = myController4.text;
    String monedaValue = myController5.text;
    String estadoValue = myController6.text;
    String zonaValue = myController7.text;
    String bancoValue = myController8.text;
    String instrumentoValue = myController9.text;
    String depositoValue = myController10.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value) {
      prefs.setString('login', loginValue);
      prefs.setString('password', passwordValue);
      prefs.setString('direccion', direccionValue);
      prefs.setString('compania', companiaValue);
      prefs.setString('moneda', monedaValue);
      prefs.setString('estado', estadoValue);
      prefs.setString('zona', zonaValue);
      prefs.setString('banco', bancoValue);
      prefs.setString('instrumento', instrumentoValue);
      prefs.setString('deposito', depositoValue);

    } else {
      prefs.remove('login');
      prefs.remove('password');
      prefs.remove('direccion');
      prefs.remove('compania');
      prefs.remove('moneda');
      prefs.remove('estado');
      prefs.remove('zona');
      prefs.remove('banco');
      prefs.remove('instrumento');
      prefs.remove('deposito');

    }
    // Guardar el estado del checkbox
    prefs.setBool('isChecked', value);

    // Agregar logs para verificar los datos guardados
    print('Datos guardados en SharedPreferences:');
    print('Login: $loginValue');
    print('Password: $passwordValue');
    print('Dirección: $direccionValue');
    print('Moneda: $monedaValue');
    print('Estado del checkbox: $value');
  }

  void _loadSavedData() async {
    // Cargar los valores guardados desde SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      myController.text = prefs.getString('login') ?? '';
      myController2.text = prefs.getString('password') ?? '';
      myController3.text = prefs.getString('direccion') ?? '';
      myController4.text = prefs.getString('compania') ?? '';
      myController5.text = prefs.getString('moneda') ?? '';
      myController6.text = prefs.getString('estado') ?? '';
      myController7.text = prefs.getString('zona') ?? '';
      myController8.text = prefs.getString('banco') ?? '';
      myController9.text = prefs.getString('instrumento') ?? '';
      myController10.text = prefs.getString('deposito') ?? '';

      _isChecked = prefs.getBool('isChecked') ?? false; // Cargar el estado del checkbox
    });

    // Agregar logs para verificar los datos cargados
    print('Datos cargados desde SharedPreferences:');
    print('Login: ${myController.text}');
    print('Password: ${myController2.text}');
    print('Dirección: ${myController3.text}');
    print('compania: ${myController4.text}');
    print('Estado del checkbox cargado: $_isChecked');
  }

  //para las traducciones
  late Map<String, String> translations = {};

  void _toggleLanguage() {
    setState(() {
      // Cambiar el idioma y las traducciones basado en el idioma actual
      if (isEnglish) {
        _cambiarIdioma('en'); // Cambiar al español
        isEnglish = false; // Cambiar el estado del idioma
      } else {
        _cambiarIdioma('es'); // Cambiar al inglés
        isEnglish = true; // Cambiar el estado del idioma
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Cargar los datos al iniciar la aplicación
    // Inicializar las traducciones en el idioma por defecto (español, por ejemplo)
    if (languageCode == 'en') {
      translations = {
        'Usuario': 'Usuario',
        'Contraseña': 'Contraseña',
        'Iniciar sesión': 'Iniciar sesión',
        'RECORDAR': 'RECORDAR',
        "COMPANIA": "COMPANIA",
        "MONEDA":"MONEDA",
        "ESTADO": "ESTADO",
        "ZONA": "ZONA",
        "BANCO": "BANCO",
        "INSTRUMENTO": "INSTRUMENTO",
        "DEPOSITO": "DEPOSITO",
        "CONFIRMAR": "CONFIRMAR"
      };
    } else {
      translations = {
        'Usuario': 'Username',
        'Contraseña': 'Password',
        'Iniciar sesión': 'SIGN IN',
        'RECORDAR': 'REMEMBER',
        "COMPANIA": "COMPANY",
        "MONEDA":"CURRENCY",
        "ESTADO": "STATE",
        "ZONA": "ZONE",
        "BANCO": "BANK",
        "INSTRUMENTO": "INSTRUMENT",
        "DEPOSITO": "STORAGE",
        "CONFIRMAR": "CONFIRM"
      };
    }

  }
 String  languageCode = "en";

  void _cambiarIdioma( languageCode) {
    setState(() {
      if (languageCode == 'en') {
        translations = {
          'Usuario': 'Usuario',
          'Contraseña': 'Contraseña',
          'Iniciar sesión': 'Iniciar sesión',
          'RECORDAR': 'RECORDAR',
          "COMPANIA": "COMPANIA",
          "MONEDA":"MONEDA",
          "ESTADO": "ESTADO",
          "ZONA": "ZONA",
          "BANCO": "BANCO",
          "INSTRUMENTO": "INSTRUMENTO",
          "DEPOSITO": "DEPOSITO",
          "CONFIRMAR": "CONFIRMAR"
        };
      } else {
        translations = {
          'Usuario': 'Username',
      'Contraseña': 'Password',
      'Iniciar sesión': 'Sign In',
      'RECORDAR': 'REMEMBER',
      "COMPANIA": "COMPANY",
      "MONEDA":"COIN",
      "ESTADO": "STATE",
      "ZONA": "ZONE",
      "BANCO": "BANK",
      "INSTRUMENTO": "INSTRUMENT",
      "DEPOSITO": "STORAGE",
      "CONFIRMAR": "CONFIRM"
        };
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Agregar el botón de bandera en el AppBar
        actions: [
          IconButton(
            onPressed: _toggleLanguage, // Usar la función para cambiar el idioma y el icono
            icon: isEnglish
                ? Image.asset(
              'images/uk_flag.png',
              width: 40,
              height: 40,
            )
                : Image.asset(
              'images/spain_flag.jpg',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body:
      Container(
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
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: translations?['Usuario'] ?? '',                          hintStyle: TextStyle(color: Colors.grey),
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
                          hintText: translations?['Contraseña'] ?? '',                          hintStyle: TextStyle(color: Colors.grey),
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
                        title: Text(
                          translations != null ? translations['RECORDAR'] ?? '' : '',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(102, 45, 145, 30),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                          ),),
                        value: _isChecked,
                        activeColor: Color.fromRGBO(102, 45, 145, 30),
                        checkColor: Colors.white,
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              _isChecked = value; // Actualiza el estado del checkbox
                            });
                            _saveData(_isChecked);
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
                                      direccion = myController3.text;
                                      global.direc = myController3.text;

                                    }
                                    if (emisor.isEmpty){
                                      emisor = myController4.text;
                                      global.emisor = myController4.text;
                                    }
                                    if(login.isEmpty){
                                      login = myController.text;
                                      usuarioGlobal = myController.text;
                                      global.user = myController.text;
                                    }
                                    if(password.isEmpty){
                                      password = myController2.text;
                                      contraGlobal= myController2.text;
                                      global.pass = myController2.text;
                                    }
                                    if(moneda.isNotEmpty){
                                      monedaGlobal = myController5.text;
                                    }
                                    if(deposito.isNotEmpty){
                                      depositoGlobal = myController11.text;
                                    }
                                    print('Login: ${myController.text}');
                                    print('Password: ${myController2.text}');
                                    print('Dirección: ${myController3.text}');
                                    print('compania: ${myController4.text}');

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

                                    _saveData(_isChecked); // Guardar datos cuando cambia el campo de usuario

                                    //transformo el usuario y contraseña en base 64
                                    autorizacionGlobal = 'Basic '+base64Encode(utf8.encode('$login:$password'));
                                    print(autorizacionGlobal );
                                    //Navigator.pushNamed(context, "/congrats");

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
                                      _saveData(_isChecked); // Guardar datos cuando cambia el campo de usuario


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
                                          child:  Text(
                                              translations != null ? translations['Iniciar sesión'] ?? '' : '',                                              textAlign: TextAlign.center),
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
                                hintText: translations?['COMPANIA'] ?? '',
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
                                hintText: translations?['MONEDA'] ?? '',
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
                              decoration:  InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: translations?['ESTADO'] ?? '',
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
                                      decoration:  InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: translations?['ZONA'] ?? '',
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
                              decoration:  InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: translations?['BANCO'] ?? '',
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
                              decoration:  InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: translations?['INSTRUMENTO'] ?? '',
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
                                      decoration:  InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: translations?['DEPOSITO'] ?? '',
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
                              if (myController3.text.toString().isEmpty) {
                                setState(() {
                                  isUrlValid = false;
                                });
                              }
                              if (myController4.text.toString().isEmpty) {
                                setState(() {
                                  isCompaniaValid = false;
                                });
                              }
                              if (myController5.text.toString().isEmpty) {
                                setState(() {
                                  isMonedaValid = false;
                                });
                              }

                              if (isUrlValid && isCompaniaValid && isMonedaValid) {
                                controller.animateToPage(
                                  0, // Índice de la página que contiene los campos de usuario y contraseña
                                  duration: Duration(milliseconds: 500), // Duración de la animación
                                  curve: Curves.ease, // Curva de animación
                                );
                              }
                            },
                            child: Ink(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children:[
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      //  constraints: const BoxConstraints(minWidth: 88.0),
                                      child:  Text(
                                          translations?['CONFIRMAR'] ?? '',
                                          textAlign: TextAlign.center),
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

  Future<void> _cargarPreferencias() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    value = prefs.getString("TestString_key")!;
    value2 = prefs.getString("TestString_key2")!;
    value3 = prefs.getString("TestString_key3")!;
    value4 = prefs.getString("TestString_key4")!;
    value5 = prefs.getString("TestString_key5")!;
    value6 = prefs.getString("TestString_key6")!;
    value7 = prefs.getString("TestString_key7")!;
    value8 = prefs.getString("TestString_key8")!;
    value9 = prefs.getString("TestString_key9")!;
    value10 = prefs.getString("TestString_key10")!;
    value11 = prefs.getString("TestString_key11")!;


    print(value + value2 +value3 +value4);

    myController.text = value;
    myController2.text = value2;
    myController3.text = value3;
    myController4.text = value4;
    myController5.text = value5;
    myController6.text = value6;
    myController7.text = value7;
    myController8.text = value8;
    myController9.text = value9;
    myController10.text = value10;
    myController11.text = value11;

    setState(() {
      _isChecked = (prefs.getBool('isChecked') ?? false);
    });
  }
}





















