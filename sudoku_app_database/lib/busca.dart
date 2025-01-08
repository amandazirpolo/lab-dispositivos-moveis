import 'package:flutter/material.dart';
import 'bancoDeDados.dart';

class Busca extends StatefulWidget {
  final String nomeJogador;
  final BancoDados bancoDados;
  const Busca({super.key, required this.nomeJogador, required this.bancoDados});

  @override
  State<Busca> createState() => _BuscaState();
}

class _BuscaState extends State<Busca> {
  String textoResultadoEasy = '';
  String textoResultadoMedium = '';
  String textoResultadoHard = '';
  String textoResultadoExpert = '';
  List<Map<String, dynamic>> dadosUsuario = [];
  List<Map<String, dynamic>> todosOsUsuarios = [];

  Widget exibirResultado(String texto) {
    if (texto.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget exibirDadosUsuario(List<Map<String, dynamic>> dados) {
    if (dados.isNotEmpty) {
      String nome = dados[0]['name'];
      int vitorias = 0;
      int derrotas = 0;

      List<Widget> widgets = [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Usuário: $nome',
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ];

      // conta o numero de vitorias e de derrotas
      for (var dado in dados) {
        if (dado['result'] == 1) {
          vitorias++;
        } else {
          derrotas++;
      }

      // adiciona a lista para poder printar os dados da query
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          'Resultado: ${dado['result']} | Nível: ${dado['level']} | Data: ${dado['date']}',
          style: const TextStyle(color: Colors.black, fontSize: 16),) ,
          )
        );
      }

      // adiciona a lista para poder printar as vitorias e as derrotas
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          'Vitórias: $vitorias | Derrotas: $derrotas',
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ));

      // retorna a lista de widgets
      return Column(children: widgets); 
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          'Nenhum dado encontrado.',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      );
    }
  }


  Widget exibirDadosTodosOsUsuarios(List<Map<String, dynamic>> dados) {
    if (dados.isNotEmpty) {
      List<Widget> widgets = [];
      String? nomeAnterior;
      int vitorias = 0;
      int derrotas = 0;

      for (var dado in dados) {
        String nome = dado['name'];

        // se trocou o jogador ent printa as vitorias e as derrotas dele
        if (nome != nomeAnterior) {
          if (nomeAnterior != null) {
            // mostra na tela
            widgets.add(Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Vitórias: $vitorias | Derrotas: $derrotas',
                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ));
          }

          //  mostra o nome do jogador
          widgets.add(Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Usuário: $nome',
              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ));

          // reseta as vitorias e as derrotas
          vitorias = 0;
          derrotas = 0;
        }

        // conta as vitorias e as derrotas
        if (dado['result'] == 1) {
          vitorias++;
        } else {
          derrotas++;
        }

        // mostra os dados da query
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'Resultado: ${dado['result']} | Nível: ${dado['level']} | Data: ${dado['date']}',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ));

        // atualiza o nome do jogador
        nomeAnterior = nome; 
      }

      // exibe a contagem para o ultimo jogador
      if (nomeAnterior != null) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'Vitórias: $vitorias | Derrotas: $derrotas',
            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ));
      }

      // mostra tudo na tela
      return Column(children: widgets); // Exibe todos os widgets na tela
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          'Nenhum dado encontrado.',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sudoku App'),
      ),
      body: SingleChildScrollView( 
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              ElevatedButton(onPressed: () async {
                var dados = await widget.bancoDados.getDadosUsuario(widget.nomeJogador);
                 if (dados.isNotEmpty) {
                  setState(() {
                    dadosUsuario = dados; 
                  });
                } 
              }, 
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177)),
                ),
                child: const Text(
                  'Infos do Jogador',
                  style: TextStyle(color: Colors.black),
                ),),
              exibirDadosUsuario(dadosUsuario),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () async {
                int partidas = await widget.bancoDados.getPartidasPorDificuldade('Easy');
                setState(() {
                  textoResultadoEasy = 'Número de partidas Easy: $partidas'; 
                });
              }, 
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177)),
                ),
                child: const Text(
                  'Número de partidas Easy',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              exibirResultado(textoResultadoEasy),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () async {
                int partidas = await widget.bancoDados.getPartidasPorDificuldade('Medium');
                setState(() {
                  textoResultadoMedium = 'Número de partidas Medium: $partidas'; 
                });
              }, 
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177)),
                ),
              child: const Text(
                'Número de partidas Medium',
                style: TextStyle(color: Colors.black),
                ),
              ),
              exibirResultado(textoResultadoMedium),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () async {
                int partidas = await widget.bancoDados.getPartidasPorDificuldade('Hard');
                setState(() {
                  textoResultadoHard = 'Número de partidas Hard: $partidas'; 
                });
              }, 
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177)),
                ),
                child: const Text(
                  'Número de partidas Hard',
                  style: TextStyle(color: Colors.black),
                ),),
              exibirResultado(textoResultadoHard),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () async {
                int partidas = await widget.bancoDados.getPartidasPorDificuldade('Expert');
                setState(() {
                  textoResultadoExpert = 'Número de partidas Expert: $partidas'; 
                });
              }, 
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177)),
                ),
                child: const Text(
                  'Número de partidas Expert',
                  style: TextStyle(color: Colors.black),
                ),),
              exibirResultado(textoResultadoExpert),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () async {
                var dados = await widget.bancoDados.getTodosOsUsuarios();
                 if (dados.isNotEmpty) {
                  setState(() {
                    todosOsUsuarios = dados; 
                  });
                } 
              }, 
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177)),
                ),
                child: const Text(
                  'Infos do Jogador',
                  style: TextStyle(color: Colors.black),
                ),),
              exibirDadosTodosOsUsuarios(todosOsUsuarios),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
              }, 
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 246, 142, 177)),
                ),
                child: const Text(
                  'Voltar',
                  style: TextStyle(color: Colors.black),
                ),),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}