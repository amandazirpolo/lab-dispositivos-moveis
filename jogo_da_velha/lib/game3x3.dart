import 'package:flutter/material.dart';
import 'dart:math';

class Game3x3 extends StatefulWidget {
  const Game3x3({super.key});

  @override
  State<Game3x3> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Game3x3> {
  List positions = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
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
   // bool state = args['state'] as bool;
    int rounds = args['rounds'] as int;

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
    //round = rounds;

    return Scaffold(
        appBar: AppBar(
          title: Text("Jogo da Velha"),
          backgroundColor: Color.fromARGB(255, 246, 142, 177),
        ),
        backgroundColor: Color.fromARGB(255, 255, 226, 232),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AbsorbPointer(
                absorbing: !state,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(info,
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button3x3(row: 0, column: 0),
                      button3x3(row: 0, column: 1),
                      button3x3(row: 0, column: 2),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button3x3(row: 1, column: 0),
                      button3x3(row: 1, column: 1),
                      button3x3(row: 1, column: 2),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button3x3(row: 2, column: 0),
                      button3x3(row: 2, column: 1),
                      button3x3(row: 2, column: 2),
                    ],
                  ),
                  returnButton()
                  // AbsorbPointer(
                  //   absorbing: state,
                  //   child: Opacity(
                  //     opacity: ,
                  //     child: returnButton())
                  // )
                ]))
          ],
        ));
  }

  Widget button3x3({required int row, required int column}) {
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
                fixedSize: const Size(100, 100),
                backgroundColor: Color.fromARGB(255, 246, 142, 177)),
            child: Text(
              positions[row][column],
              style: TextStyle(fontSize: 50, color: Colors.black),
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
              Color.fromARGB(255, 246, 142, 177)), // Define a cor do botão
        ),
        child: Text(
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
    // se nao tem vencedor e aconteceram 9 jogadas é pq teve empate
    else if ((hasWinner == false) && (round == 9)) {
      info = 'Empate!';
    }
    // se nao tem vencedor e nao aconteceram 9 jogadas atualiza as posicoes
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
    for (int i = 0; i < 3; i++) {
      if (positions[row][i] == gamerTime) {
        tmp = true;
      } else {
        tmp = false;
        break;
      }
    }
    // olha a coluna
    if (tmp == false) {
      for (int i = 0; i < 3; i++) {
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
          (positions[2][2] == gamerTime)) {
        tmp = true;
      }
    }
    // olha diagonal secundaria
    if (tmp == false) {
      if ((positions[0][2] == gamerTime) &&
          (positions[1][1] == gamerTime) &&
          (positions[2][0] == gamerTime)) {
        tmp = true;
      }
    }
    return tmp;
  }
}
