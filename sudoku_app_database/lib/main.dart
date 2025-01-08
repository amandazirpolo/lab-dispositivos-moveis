import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'bancoDeDados.dart';
import 'busca.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final bancoDados = BancoDados();
  await bancoDados.bd; 

  runApp(MyApp(bancoDados: bancoDados));

}

class MyApp extends StatelessWidget {
  final BancoDados bancoDados;
  const MyApp({super.key, required this.bancoDados});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 246, 142, 177)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Sudoku App', bancoDados: bancoDados),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.bancoDados});
  final String title;
  final BancoDados bancoDados;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nome = TextEditingController();
  String? valorRadio;
  Sudoku? sudoku;
  List<int> matrizGerada = List.generate(81, (_) => -1); 
  List<int> matrizPreenchida = List.generate(81, (_) => -1);   int linha = -1;
  List<List<int>> historicoJogo = [];
  int? idJogador;
  int coluna = -1;
  bool tabuleiro = false;
  bool vitoria = false;
  Map<String, Level> dificuldade = {
    "1": Level.easy,
    "2": Level.medium,
    "3": Level.hard,
    "4": Level.expert,
  };

  Color corMatriz(int index) {
    int linha = index ~/ 9;
    int coluna = index % 9;
    Color cor;

    if (linha < 3 || linha > 5) {
      if (coluna < 3) {
        cor = const Color.fromARGB(255, 255, 226, 232);
      } else if (coluna < 6) {
        cor = const Color.fromARGB(255, 246, 142, 177);
      } else {
        cor = const Color.fromARGB(255, 255, 226, 232);
      }
    } else {
      if (coluna < 3) {
        cor = const Color.fromARGB(255, 246, 142, 177);
      } else if (coluna < 6) {
        cor = const Color.fromARGB(255, 255, 226, 232);
      } else {
        cor = const Color.fromARGB(255, 246, 142, 177);
      }
    }
    return cor;
  }

  void salvarEstado(){
    historicoJogo.add(List.from(matrizPreenchida));
  }

  void voltarJogada() {
    if (historicoJogo.isNotEmpty) {
      setState(() {
        matrizPreenchida = List.from(historicoJogo.removeLast());
        vitoria = checarSeGanhou();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há jogadas anteriores.')),
      );
    }
  }

  void gerarTabuleiro() {
    Level level = dificuldade[valorRadio]!;
    sudoku = Sudoku.generate(level);

    matrizGerada = List.generate(81, (index) {
      return sudoku?.puzzle[index] ?? -1;
    });
    
    setState(() {
      tabuleiro = true;
      vitoria = false;
      matrizPreenchida = List.generate(81, (_) => -1);
    });

  }

  bool posicaoValida(int valorInserido, int index){
    int l = index ~/ 9;
    int c = index % 9;
    int subMatrizL = l ~/ 3 * 3; 
    int subMatrizC = c ~/ 3 * 3;

    // checa a linha
    for(int i = 0; i < 9; i++){
      if((matrizPreenchida[l * 9 + i] == valorInserido) || (matrizGerada[l * 9 + i] == valorInserido)){
      return false;
      }
    }

    // checa a coluna
    for(int i = 0; i < 9; i++){
      if((matrizPreenchida[i * 9 + c] == valorInserido) || (matrizGerada[i * 9 + c] == valorInserido)){
        return false;
      }
    }

    // checa a submatriz 3x3
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < 3; j++){
        if((matrizPreenchida[(subMatrizL + i) * 9 + (subMatrizC + j)] == valorInserido) || (matrizGerada[(subMatrizL + i) * 9 + (subMatrizC + j)] == valorInserido)){
          return false;
        }
      }
    }

    return true;
  }

  bool tabuleiroCompleto() {
  for (int i = 0; i < 81; i++) {
    int valor = matrizPreenchida[i] > 0
        ? matrizPreenchida[i]
        : matrizGerada[i];
    if (valor <= 0 || valor > 9) {
      return false;
    }
  }
  return true;
}

  bool checarSeGanhou() {
    if (!tabuleiroCompleto()) {
      return false;
    }
    else{
      return true;
    }
  }

  void reiniciar(){
    setState(() {
      tabuleiro = false;
      vitoria = false;
      matrizGerada = List.generate(81, (_) => -1);
      matrizPreenchida = List.generate(81, (_) => -1);
      historicoJogo.clear(); 
    });
  }
 
  void checarSeTerminou() async{
    if (checarSeGanhou()) {
      await widget.bancoDados.atualizarResultado(nome.text, idJogador);
      setState(() {
        vitoria = true;
      });
    } else {
      if (!tabuleiroCompleto()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ainda há buracos no tabuleiro. Continue preenchendo!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Existem números incorretos no tabuleiro. Corrija e tente novamente!')),
        );
      }
    }
  }

  String checarDificuldade(String valorRadio){
    switch(valorRadio){
      case "1":
        return "Easy";
      case "2":
        return "Medium";
      case "3":
        return "Hard";
      case "4":
        return "Expert";
      default:
        return "Easy";
    }
  }

  Widget _tabuleiroSudoku() {
    return Center(
      child: Column(
        children: List.generate(9, (linha) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(9, (coluna) {
              int index = linha * 9 + coluna;
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  if (matrizGerada[index] == -1) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text('Selecione um número'),
                          content: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(9, (i) {
                              int numeroEscolhido = i + 1;
                              return GestureDetector(
                                onTap: () {
                                  if (posicaoValida(numeroEscolhido, index)) {
                                    setState(() {
                                      matrizPreenchida[index] = numeroEscolhido;
                                      salvarEstado();
                                    });
                                    Future.delayed(const Duration(milliseconds: 100), () {
                                      Navigator.of(context).pop();
                                      checarSeTerminou();
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$numeroEscolhido já selecionado, escolha outra posição'),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 246, 142, 177),
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    numeroEscolhido.toString(),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    color: corMatriz(index),
                  ),
                  child: Center(
                    child: Text(
                      matrizPreenchida[index] > 0
                          ? matrizPreenchida[index].toString()
                          : matrizGerada[index] > 0
                              ? matrizGerada[index].toString()
                              : '',
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView( 
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Digite seu nome aqui',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Amanda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    filled: false,
                    fillColor: Colors.grey[200],
                  ),
                  controller: nome,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20), 
                child: Text(
                  'Selecione a dificuldade do jogo:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              RadioListTile(
                title: const Text("Easy"),
                value: "1",
                groupValue: valorRadio,
                onChanged: (String? val) {
                  valorRadio = val;
                  setState(() {});
                },
                activeColor: const Color.fromARGB(255, 246, 142, 177),
              ),
              RadioListTile(
                title: const Text("Medium"),
                value: "2",
                groupValue: valorRadio,
                onChanged: (String? val) {
                  valorRadio = val;
                  setState(() {});
                },
                activeColor: const Color.fromARGB(255, 246, 142, 177),
              ),
              RadioListTile(
                title: const Text("Hard"),
                value: "3",
                groupValue: valorRadio,
                onChanged: (String? val) {
                  valorRadio = val;
                  setState(() {});
                },
                activeColor: const Color.fromARGB(255, 246, 142, 177),
              ),
              RadioListTile(
                title: const Text("Expert"),
                value: "4",
                groupValue: valorRadio,
                onChanged: (String? val) {
                  valorRadio = val;
                  setState(() {});
                },
                activeColor: const Color.fromARGB(255, 246, 142, 177),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  if (nome.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Digite o nome do usuário!")),
                    );
                    return;
                  }
                  if (valorRadio == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Selecione a dificuldade do jogo!")),
                    );
                    return;
                  }
                  String nivel = checarDificuldade(valorRadio!);
                  idJogador = await widget.bancoDados.insereDados(nome.text, 0, nivel);
                  gerarTabuleiro();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177)),
                ),
                child: const Text(
                  'Jogar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              if (tabuleiro) ...[
                const SizedBox(height: 20),
                Text(
                  'Oi, ${nome.text}! :)',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                _tabuleiroSudoku(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: checarSeTerminou,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177),
                    ),
                  ),
                  child: const Text(
                    'Checar vitória',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                if(vitoria) ... [
                  const SizedBox(height: 20),
                  const Text(
                    'Parabéns, você ganhou!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: reiniciar,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color.fromARGB(255, 246, 142, 177)),
                    ),
                    child: const Text('Jogar Novamente',
                      style: TextStyle(color: Colors.black)),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: voltarJogada,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 246, 142, 177)),
                  ),
                  child: const Text('Voltar Jogada',
                    style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Busca(nomeJogador: nome.text, bancoDados: widget.bancoDados),
                    ),
                  );
                }, 
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177)),
                ),
                child: const Text(
                  'Estatísticas',
                  style: TextStyle(color: Colors.black),
                ),
               ),
                ],
              ],
          ),
        ),
      ),
    );
  }
}
