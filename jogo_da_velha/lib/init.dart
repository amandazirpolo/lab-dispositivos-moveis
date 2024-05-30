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
          title: const Text("Jogo da Velha"),
          backgroundColor: const Color.fromARGB(255, 246, 142, 177),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 226, 232),
        body: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        10.0), // espaço entre o topo da tela e o campo de texto
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Digite seu nome aqui',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Amanda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                    ),
                    filled: false,
                    fillColor: Colors.grey[200],
                  ),
                  controller: nameController,
                ),
              ),
              const Text(
                'Selecione o tamanho da matriz do jogo:',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),  
              RadioListTile(
                  title: const Text("3 x 3"),
                  value: "3",
                  groupValue: valueRadioMat,
                  onChanged: (String? val) {
                    valueRadioMat = val;
                    radio1 = true;
                    setState(() {});
                  },
                  activeColor: const Color.fromARGB(255, 246, 142, 177)),
              RadioListTile(
                  title: const Text("4 x 4"),
                  value: "4",
                  groupValue: valueRadioMat,
                  onChanged: (String? val) {
                    valueRadioMat = val;
                    radio1 = true;
                    setState(() {});
                  },
                  activeColor: const Color.fromARGB(255, 246, 142, 177)),
              const Text(
                'Selecione o símbolo a ser usado:',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              RadioListTile(
                  title: const Text("O"),
                  value: "O",
                  groupValue: gamerSymbol,
                  onChanged: (String? val) {
                    gamerSymbol = val;
                    machineSymbol = "X";
                    radio2 = true;
                    setState(() {});
                  },
                  activeColor: const Color.fromARGB(255, 246, 142, 177)),
              RadioListTile(
                  title: const Text("X"),
                  value: "X",
                  groupValue: gamerSymbol,
                  onChanged: (String? val) {
                    gamerSymbol = val;
                    machineSymbol = "O";
                    radio2 = true;
                    setState(() {});
                  },
                  activeColor: const Color.fromARGB(255, 246, 142, 177)),
              ElevatedButton(
                onPressed: () {
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
                              }
                            );
                      } else {
                        await Navigator.pushNamed(context, 'game4x4',
                            arguments: {
                              'gamerName': nameController.value.text,
                              'machineName': nameMachine,
                              'gamerSymbol': gamerSymbol,
                              'machineSymbol': machineSymbol
                            }
                          );
                        }
                      }
                    }
                  );
                  setState(() {});
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(
                          255, 246, 142, 177)), // define a cor do botao
                ),
                child: const Text(
                  'Jogar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )
        )
      );
  }
}
