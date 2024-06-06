import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textController = TextEditingController();
  String text = "";

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nome", textController.text);
  }

  void _recover() async {
    final prefs = await SharedPreferences.getInstance();
    text = prefs.getString("nome")!;
    setState(() {});
  }

  void _remove() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("nome");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Shared Preferences App"),
          backgroundColor: Colors.purple),
      body: Center(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Texto: $text ", style: TextStyle(fontSize: 20)),
            TextField(
                keyboardType: TextInputType.text, controller: textController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _save, child: Text("Salvar")),
                ElevatedButton(onPressed: _recover, child: Text("Recuperar")),
                ElevatedButton(onPressed: _remove, child: Text("Remover")),
              ],
            )
          ],
        ),
      )),
    );
  }
}
