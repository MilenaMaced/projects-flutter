import 'package:flutter/material.dart';
import 'package:buscador_gifs/pages/buscador_gif.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  const BuscadorGif(),
      theme: ThemeData(
        hintColor: Colors.white,
      ),
    );
  }
}
