import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lista_deseos/pages/page_add_task.dart';
import 'package:lista_deseos/pages/page_login.dart';
import 'package:lista_deseos/pages/page_main.dart';
import 'package:lista_deseos/pages/page_add_responsible.dart';

Future<void> main() async {

  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Deseo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => const Login(),
      },
      initialRoute: 'login',
    );
  }
}

