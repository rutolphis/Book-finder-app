import 'package:flutter/material.dart';
import 'package:zadanie_praca/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyhladávač kníh',
      theme: ThemeData(

        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
    );
  }
}

