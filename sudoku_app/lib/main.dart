import 'package:flutter/material.dart';
import 'game.dart';
import 'page1.dart';

void main() {
  runApp(MaterialApp(
    title: "Jogo da Velha",
    debugShowCheckedModeBanner: false,
    initialRoute: 'init',
    routes: {
      'game': (context) => const Game(),
      'page1': (context) => const Page1()
    },
  ));
}

