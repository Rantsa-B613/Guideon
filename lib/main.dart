import 'package:bard_flutter/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "Votre texte ici"; // Remplacez par le texte que vous souhaitez afficher

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BARD FLUTTER',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF956DE5),
        useMaterial3: true,
      ),
      home: HomePage(), // Passez le texte ici
    );
  }
}
