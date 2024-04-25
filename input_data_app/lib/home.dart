import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State Home> createState() =>  HomeState();
// }

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String dados = " ";
  bool? checkbox1 = false;
  bool? checkbox2 = false;
  bool? checkbox3 = false;
  String? radio1;
  bool switch1 = false;
  double slider1 = 5;
  String _label = " ";

  void _save() {
    print("${nomeController.text}, ${emailController.text}");
    dados = nomeController.text + ", " + emailController.text;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Entrada de Dados"), backgroundColor: Colors.blue),
        body: Center(
            child: Container(
                child: Column(children: [
          Slider(
            divisions: 10,
            label: _label,
            min: 0,
            max: 10,
            activeColor: Colors.red,
            inactiveColor: Colors.purple,
            value: slider1,
            onChanged: (double val) {
              print("Slider: $val");
              slider1 = val;
              _label = "Valor: " + val.toString();
              setState(() {});
            },
          ),
          TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Digite o nome:",
                  labelStyle: TextStyle(fontSize: 30)),
              enabled: true,
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              style: TextStyle(fontSize: 30),
              obscureText: false,
              onChanged: (String value) {
                print("onChanged: $value");
              },
              onSubmitted: (String value) {
                print("onSubmitted: $value");
              },
              controller: nomeController),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "Digite o email:",
                labelStyle: TextStyle(fontSize: 30)),
            style: TextStyle(fontSize: 30),
            controller: emailController,
          ),
          Text("Dados: $dados", style: TextStyle(fontSize: 30)),
          CheckboxListTile(
              title: Text("Churrasco"),
              subtitle: Text("misto"),
              activeColor: Colors.red,
              selected: true,
              secondary: Icon(Icons.add_box),
              value: checkbox1,
              onChanged: (bool? val) {
                print("Checkbox: $val");
                setState(() {
                  checkbox1 = val;
                });
              }),
          CheckboxListTile(
              title: Text("Frango"),
              subtitle: Text("à milanesa"),
              activeColor: Colors.red,
              selected: true,
              secondary: Icon(Icons.add_box),
              value: checkbox2,
              onChanged: (bool? val) {
                print("Checkbox: $val");
                setState(() {
                  checkbox2 = val;
                });
              }),
          Checkbox(
              value: checkbox3,
              onChanged: (bool? val) {
                print("Checkbox: $val");
                setState(() {
                  checkbox3 = val;
                });
              }),
          RadioListTile(
              title: Text("Feminino"),
              value: "f",
              groupValue: radio1,
              onChanged: (String? val) {
                print("Radio: $val");
                radio1 = val;
                setState(() {});
              }),
          RadioListTile(
              title: Text("Masculino"),
              value: "m",
              groupValue: radio1,
              onChanged: (String? val) {
                print("Radio: $val");
                radio1 = val;
                setState(() {});
              }),
          SwitchListTile(
              title: Text("Frango"),
              subtitle: Text("à milanesa"),
              activeColor: Colors.red,
              selected: true,
              secondary: Icon(Icons.add_box),
              value: switch1,
              onChanged: (bool val) {
                print("Checkbox: $val");
                setState(() {
                  switch1 = val;
                });
              }),
          ElevatedButton(
            onPressed: _save,
            child: Text("Salvar"),
          )
        ]))));
  }
}
