import 'package:flutter/material.dart';
import 'init.dart';
import 'game3x3.dart';
import 'game4x4.dart';

void main() {
  runApp(MaterialApp(
    title: "Jogo da Velha",
    debugShowCheckedModeBanner: false,
    initialRoute: 'init',
    routes: {
      'init': (context) => Init(),
      'game3x3': (context) => Game3x3(),
      'game4x4': (context) => Game4x4()
    },
  ));
}
