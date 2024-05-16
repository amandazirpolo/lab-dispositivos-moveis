import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FutureHome extends StatefulWidget {
  const FutureHome({super.key});

  @override
  State<FutureHome> createState() => _FutureHomeState();
}

class _FutureHomeState extends State<FutureHome> {
  TextEditingController cepController = TextEditingController();
  String logradouro = "", bairro="", cidade="";

  Future<Map> getCep() async{
    if(cepController.text.isNotEmpty){
      String cep = cepController.text;
      String url = "https://viacep.com.br//ws/$cep/json/";
      http.Response response = await http.get(Uri.parse(url));
      //print(response.body);
      //print(response.statusCode);
      
      Map<String, dynamic> ret = jsonDecode(response.body);
      logradouro = ret["logradouro"];
      bairro = ret["bairro"];
      cidade = ret["localidade"];
      return ret;
    }
    
    return{
      "logradouro": "",
      "bairro": "",
      "cidade" : ""
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Via CEP"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          child: Column(children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: cepController,
              decoration: InputDecoration(
                labelText: "Cep",
              ),
            ),
            ElevatedButton(
              onPressed: getCep,
              child: Text("Buscar")),
            FutureBuilder(future: getCep(), builder: (context, snapshot){
              String result = "";
              if(snapshot.hasData){
                result = snapshot.data!["localidade"];
              }
              else if(snapshot.hasError){
                result = snapshot.error.toString();
              }else{
                return CircularProgressIndicator();
              }
              return Text(result);
            }),
            Text("Localidade: $logradouro"),
            Text("Bairro: $bairro"),
            Text("Cidade: $cidade"),
          ],)
        )
      ),);}
}