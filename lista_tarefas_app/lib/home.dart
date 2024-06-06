import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> taskList = [];

  Widget listItemBuild(BuildContext context, int index) {
    return CheckboxListTile(
        title: Text(taskList[index]["title"]),
        value: taskList[index]["done"],
        onChanged: (bool? val) {
          taskList[index]["done"] = val;
          setState(() {});
          _saveFile();
        });
  }

  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();

    readFile().then((data) {
      taskList = jsonDecode(data);
      setState(() {});
    });
  }

  Future<String> readFile() async {
    final file = await getFile();
    return file.readAsString();
  }

  void _saveFile() async {
    final file = await getFile();
    String dataJson = jsonEncode(taskList);
    file.writeAsString(dataJson);
  }

  Future<File> getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    String pathFile = dir.path + "/task.json";
    return File(pathFile);
  }

  void _saveTask() {
    String taskStr = taskController.text;

    Map<String, dynamic> task = Map();
    task["title"] = taskStr;
    task["done"] = false;

    setState(() {
      taskList.add(task);
    });

    _saveFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Tarefas"),
          backgroundColor: Colors.lightBlue,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            taskController.clear();
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Adicionar Tarefa"),
                    content: TextField(
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(labelText: "Digite sua Tarefa"),
                        controller: taskController),
                    actions: [
                      TextButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text("Salvar"),
                        onPressed: () {
                          _saveTask();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          },
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: listItemBuild,
              ))
            ],
          ),
        ));
  }
}
