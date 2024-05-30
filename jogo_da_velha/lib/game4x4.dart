import 'package:flutter/material.dart';

class Game4x4 extends StatefulWidget {
  const Game4x4({super.key});

  @override
  State<Game4x4> createState() => _Game4x4State();
}

class _Game4x4State extends State<Game4x4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogo da Velha"),
        backgroundColor: Color.fromARGB(255, 246, 142, 177),
      ),
      backgroundColor: Color.fromARGB(255, 255, 226, 232),
      body: Center(
        child: Container(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // button3x3(row: 0, column: 0),
                // button3x3(row: 0, column: 1),
                // button3x3(row: 0, column: 2),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // button3x3(row: 1, column: 0),
                // button3x3(row: 1, column: 1),
                // button3x3(row: 1, column: 2),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // button3x3(row: 2, column: 0),
                // button3x3(row: 2, column: 1),
                // button3x3(row: 2, column: 2),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('info',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  //state = false;
                  Navigator.pop(context, 'state');
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(
                        255, 246, 142, 177)), // Define a cor do botão
              ),
              child: Text(
                'Jogar novamente',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
