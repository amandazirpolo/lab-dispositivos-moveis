import "package:flutter/material.dart";

void main() {
  // hello world do dart
  runApp(MaterialApp(
      title: "aula_040424",
      debugShowCheckedModeBanner:
          false, // tira a barrinha do debug que aparece na parte do app
      home: Container(
          // responsavel por configurar a interface
          // color: Colors.pinkAccent,
          padding: EdgeInsets.only(top: 100, left: 10, right: 20, bottom: 10),
          margin: EdgeInsets.only(left: 100, top: 50),
          decoration: BoxDecoration(
              color: Colors.pinkAccent,
              border: Border.all(
                  width: 5, color: const Color.fromARGB(255, 85, 7, 220))),
          // cada child eh um widget do container
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // children sao os widgets de child
            // funciona como uma estrutura de arvore
            children: [
              Text("Widget 1"),
              Text("Hello World!",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 10,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.deepOrange,
                      decorationStyle: TextDecorationStyle.dotted)),
              Text("Widget 3"),
              TextButton(
                  onPressed: () {
                    // print("TextButton Clicado!");
                  },
                  child: Text("Clique Aqui!!")
              ),
              ElevatedButton(
                onPressed: () {
                // print("Elevated Button clicado");
                },
                child: Text("Clique Aqui!!")
              ),
              IconButton(
                  onPressed: () {
                    // print("IconButton clicado!!");
                  },
                  icon: Icon(Icons.add)
              ),
              GestureDetector(
                onTap: () {
                  // print("Gesture Detector TAP");
                },
                child: Text("Gesture Detector")
              )  
            ],
          )
        )
      )
    );
}
