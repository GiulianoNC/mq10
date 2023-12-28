import 'package:flutter/material.dart';
import 'package:mq10/Layouts/cobranzas/cobrarDeuda_screen.dart';
import 'package:provider/provider.dart';
import 'Herramientas/SplashScreen.dart';
import 'Layouts/actualizacion.dart';
import 'Layouts/cobranzas/cobranza_screen.dart';
import 'Layouts/cobranzas/cobrarAnticipo_screen.dart';
import 'Layouts/login_screen.dart';
import 'Layouts/mail_screeen.dart';
import 'Layouts/nuevo_cliente.dart';
import 'Layouts/pedidos/pedidoNuevo_screen.dart';
import 'Layouts/pedidos/pedidos_screen.dart';
import 'Layouts/primera.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ClienteModel>(
          create: (_) => ClienteModel(),
        ),
        ChangeNotifierProvider<EstadoModel>(
          create: (_) => EstadoModel(),
        ),
        ChangeNotifierProvider<PedidoModel>(
          create: (_) => PedidoModel(),
        ),
        // Otros providers si los tienes
      ],
      child: MyApp(),
    ),
  );
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
        '/login': (BuildContext context) =>  LoginScreen(),
            '/congrats': ( context) =>  Primera(),
        '/nuevoCliente': ( context) =>  ClienteNuevo(),
        '/mail': ( context) =>  MailScreen(),
        '/pedidos': ( context) =>  Pedidos(),
        '/cobranza': ( context) =>  Cobranza(),
        '/pedidoNuevo': (BuildContext context) => PedidoNuevo(),
        '/cobrarDeuda': (BuildContext context) => cobrarDeuda(),
        '/cobrarAnticipo': (BuildContext context) => cobrarAnticipo(),
        '/actualizacion': (BuildContext context) => actualizacion(),

        /* '/correctivo': ( context) =>  MantenimientoScreen(),
        '/motivo': ( context) =>  motivo(),
        '/incidente': (context) => Incidente(),*/

      },
    );
  }
}
