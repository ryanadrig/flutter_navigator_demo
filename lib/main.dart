import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:navigator_demo/push_simple.dart';



void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => RCartModel()),
        // ChangeNotifierProvider(create: (_) => NProvState2()),
      ],
      child:MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const NavDemoRoot(),
    );
  }
}



