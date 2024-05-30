import 'package:flutter/material.dart';

class Init extends StatefulWidget {
  const Init({super.key});

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
  TextEditingController nameController = TextEditingController();
  String? valueRadioMat;
  String? gamerSymbol;
  String machineSymbol = " ";
  String nameMachine = "Machine";
  bool state = false, radio1 = false, radio2 = false;
  int rounds = 0;

  bool checkState() {
    return nameController.text.isNotEmpty && radio1 && radio2;
  }

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
              child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.symmetric(
                    horizontal:
                        10.0), // Espaço entre o topo da tela e o campo de texto
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Digite seu nome aqui',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Amanda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    filled: false,
                    fillColor: Colors.grey[200],
                  ),
                  controller: nameController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Selecione o tamanho da matriz do jogo:',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
              RadioListTile(
                  title: Text("3 x 3"),
                  value: "3",
                  groupValue: valueRadioMat,
                  onChanged: (String? val) {
                    print("Radio: $val");
                    valueRadioMat = val;
                    radio1 = true;
                    setState(() {});
                  },
                  activeColor: Color.fromARGB(255, 246, 142, 177)),
              RadioListTile(
                  title: Text("4 x 4"),
                  value: "4",
                  groupValue: valueRadioMat,
                  onChanged: (String? val) {
                    print("Radio: $val");
                    valueRadioMat = val;
                    radio1 = true;
                    setState(() {});
                  },
                  activeColor: Color.fromARGB(255, 246, 142, 177)),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Selecione o símbolo a ser usado:',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
              RadioListTile(
                  title: Text("O"),
                  value: "O",
                  groupValue: gamerSymbol,
                  onChanged: (String? val) {
                    print("Radio: $val");
                    gamerSymbol = val;
                    machineSymbol = "X";
                    radio2 = true;
                    setState(() {});
                    print("selecionar bolinha:");
                    print("GamerSymbol: $gamerSymbol");
                    print("MachineSymbol: $machineSymbol");
                  },
                  activeColor: Color.fromARGB(255, 246, 142, 177)),
              RadioListTile(
                  title: Text("X"),
                  value: "X",
                  groupValue: gamerSymbol,
                  onChanged: (String? val) {
                    print("Radio: $val");
                    gamerSymbol = val;
                    machineSymbol = "O";
                    radio2 = true;
                    setState(() {});
                    print("selecionar x:");
                    print("GamerSymbol: $gamerSymbol");
                    print("MachineSymbol: $machineSymbol");
                  },
                  activeColor: Color.fromARGB(255, 246, 142, 177)),
              ElevatedButton(
                onPressed: () {
                  print("nome do jogador: $nameController");
                  print("nome da maquina: $nameMachine");
                  setState(() async {
                    if (checkState()) {
                      state = true;
                      if (valueRadioMat == '3') {
                        await Navigator.pushNamed(context, 'game3x3',
                            arguments: {
                              'gamerName': nameController.value.text,
                              'machineName': nameMachine,
                              'gamerSymbol': gamerSymbol,
                              'machineSymbol': machineSymbol,
                              'state': state,
                              'rounds': rounds
                            });
                      } else {
                        await Navigator.pushNamed(context, 'game4x4',
                            arguments: {
                              'gamerName': nameController.value.text,
                              'machineName': nameMachine,
                              'gamerSymbol': gamerSymbol,
                              'machineSymbol': machineSymbol,
                              'state': state,
                            });
                      }
                    }
                  });
                  setState(() {});
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 246, 142, 177)), // Define a cor do botão
                ),
                child: Text(
                  'Jogar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )),
        ));
  }
}
