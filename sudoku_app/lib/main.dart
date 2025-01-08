import 'package:flutter/material.dart';
import 'game.dart';
import 'page1.dart';

void main() {
  runApp(MaterialApp(
    title: "Sudoku",
    debugShowCheckedModeBanner: false,
    initialRoute: 'page1',
    routes: {
      'game': (context) => const Game(),
      'page1': (context) => const Page1()
    },
  ));
}

