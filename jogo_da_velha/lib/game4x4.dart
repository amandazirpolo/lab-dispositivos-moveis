import 'package:flutter/material.dart';
import 'dart:math';

class Game4x4 extends StatefulWidget {
  const Game4x4({super.key});

  @override
  State<Game4x4> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Game4x4> {
  List positions = [
    ['', '', '', ''],
    ['', '', '', ''],
    ['', '', '', ''],
    ['', '', '', '']
  ];

  String gamerTime = '';
  String info = '';
  String gamer = '';
  String machine = '';
  String gamerS = '';
  String gamerM = '';
  int round = 0;
  bool state = true;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String gamerName = args['gamerName'] as String;
    final String machineName = args['machineName'] as String;
    final String gamerSymbol = args['gamerSymbol'] as String;
    final String machineSymbol = args['machineSymbol'] as String;

    // sorteia quem é o primeiro jogador
    Random random = Random();
    int i = random.nextInt(2);
    if (i == 0) {
      gamerTime = gamerSymbol;
    } else {
      gamerTime = machineSymbol;
    }

    /* como as variaveis so existem no override, criei uma variavel
    da classe para usar nos widgets novos */
    gamer = gamerName;
    gamerS = gamerSymbol;
    machine = machineName;
    gamerM = machineSymbol;

    // indica que o jogador pode iniciar o jogo
    if (gamerTime == gamerS) {
      info = '$gamer é a sua vez de jogar :)';
    } else {
      info = '$machine é a sua vez de jogar :)';
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Jogo da Velha"),
          backgroundColor: const Color.fromARGB(255, 246, 142, 177),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 226, 232),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AbsorbPointer(
                absorbing: !state,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(info,
                      style: const TextStyle(fontSize: 20, color: Colors.black)
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button4x4(row: 0, column: 0),
                      button4x4(row: 0, column: 1),
                      button4x4(row: 0, column: 2),
                      button4x4(row: 0, column: 3)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button4x4(row: 1, column: 0),
                      button4x4(row: 1, column: 1),
                      button4x4(row: 1, column: 2),
                      button4x4(row: 1, column: 3)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button4x4(row: 2, column: 0),
                      button4x4(row: 2, column: 1),
                      button4x4(row: 2, column: 2),
                      button4x4(row: 2, column: 3)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button4x4(row: 3, column: 0),
                      button4x4(row: 3, column: 1),
                      button4x4(row: 3, column: 2),
                      button4x4(row: 3, column: 3)
                    ],
                  ),
                ]
              )
            ),
            AbsorbPointer(
              absorbing: state,
              child: Opacity(
                opacity: state ? 0 : 1,
                child: returnButton()
              )
            )
          ],
        )
      );
  }

  Widget button4x4({required int row, required int column}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: AbsorbPointer(
          absorbing: positions[row][column] == '' ? false : true,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                game(row: row, column: column);
                bool tmp = checkWinner(gamerTime: gamerTime, row: row, column: column);
                if(tmp == true){
                  state = false;
                }
              });
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(80, 80),
                backgroundColor: const Color.fromARGB(255, 246, 142, 177)),
            child: Text(
              positions[row][column],
              style: const TextStyle(fontSize: 50, color: Colors.black),
            ),
          )),
    );
  }

  Widget returnButton() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            Navigator.pop(context, 'state');
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 246, 142, 177)), // Define a cor do botão
        ),
        child: const Text(
          'Jogar novamente',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void game({required int row, required int column}) {
    round++;
    positions[row][column] = gamerTime;
    bool hasWinner =
        checkWinner(gamerTime: gamerTime, row: row, column: column);
    String name = '';
    // checa se existe um vencedor
    if (hasWinner) {
      if (gamerTime == gamerM) {
        name = machine;
      } else {
        name = gamer;
      }
      info = '$name ganhou o jogo :)';
    }
    // se nao tem vencedor e aconteceram 16 jogadas é pq teve empate
    else if ((hasWinner == false) && (round == 16)) {
      info = 'Empate!';
    }
    // se nao tem vencedor e nao aconteceram 16 jogadas atualiza as posicoes
    else {
      // atualiza
      if (gamerTime == gamerS) {
        gamerTime = gamerM;
        name = machine;
      } else if (gamerTime == gamerM) {
        gamerTime = gamerS;
        name = gamer;
      }
      info = '$name é a sua vez de jogar!';
    }
  }

  bool checkWinner(
      {required String gamerTime, required int row, required int column}) {
    bool tmp = false;
    // primeiro olha a linha
    for (int i = 0; i < 4; i++) {
      if (positions[row][i] == gamerTime) {
        tmp = true;
      } else {
        tmp = false;
        break;
      }
    }
    // olha a coluna
    if (tmp == false) {
      for (int i = 0; i < 4; i++) {
        if (positions[i][column] == gamerTime) {
          tmp = true;
        } else {
          tmp = false;
          break;
        }
      }
    }
    // olha diagonal principal
    if (tmp == false) {
      if ((positions[0][0] == gamerTime) &&
          (positions[1][1] == gamerTime) &&
          (positions[2][2] == gamerTime) &&
          (positions[3][3] == gamerTime)) {
        tmp = true;
      }
    }
    // olha diagonal secundaria
    if (tmp == false) {
      if ((positions[0][3] == gamerTime) &&
          (positions[1][2] == gamerTime) &&
          (positions[2][1] == gamerTime) &&
          (positions[3][0] == gamerTime)) {
        tmp = true;
      }
    }
    return tmp;
  }
}
