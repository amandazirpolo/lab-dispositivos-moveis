import 'package:flutter/material.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  List<String> lista = [
    'Bom dia!',
    'Boa tarde!',
    'Boa noite!',
    'Como você está?',
    'O dia está lindo!',
    'Oiiiiiiiiiiii!',
    'Seja bem vindo!',
    'Sou aluna de Computação no IC/UFF'
  ];
  int tam = 0;
  Random random = Random();
  String frase = '';
  int pos = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frases Aleatórias"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 270.0,
              height: 230.0,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/title.png'), fit: BoxFit.fill),
              ),
            ),
            const Text("Clique abaixo para gerar uma frase!",
                style: TextStyle(fontSize: 30)),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tam = lista.length;
                  pos = Random().nextInt(tam);
                  frase = lista[pos];
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Nova Frase',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            Text(frase, 
              style: const TextStyle(fontSize: 30)
            ,)
          ],
        )),
      ),
    );
  }
}
