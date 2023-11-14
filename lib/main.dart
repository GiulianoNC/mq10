import 'package:flutter/material.dart';
import 'package:mq10/Layouts/cobranzas/cobrarDeuda_screen.dart';
import 'Herramientas/SplashScreen.dart';
import 'Layouts/cobranzas/cobranza_screen.dart';
import 'Layouts/login_screen.dart';
import 'Layouts/mail_screeen.dart';
import 'Layouts/nuevo_cliente.dart';
import 'Layouts/pedidoNuevo_screen.dart';
import 'Layouts/pedidos_screen.dart';
import 'Layouts/primera.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => const SplashScreen(),
        '/login': ( context) =>  LoginScreen(),
            '/congrats': ( context) =>  Primera(),
        '/nuevoCliente': ( context) =>  ClienteNuevo(),
        '/mail': ( context) =>  mail(),
        '/pedidos': ( context) =>  Pedidos(),
        '/cobranza': ( context) =>  Cobranza(),
        '/pedidoNuevo': (BuildContext context) => PedidoNuevo(),
        '/cobrarDeuda': (BuildContext context) => cobrarDeuda(),


        /* '/correctivo': ( context) =>  MantenimientoScreen(),
        '/motivo': ( context) =>  motivo(),
        '/incidente': (context) => Incidente(),*/

      },
    );
  }
}
