import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> getPosts() async {
    String url = baseUrl + "/posts";

    final response = await http.get(Uri.parse(url));

    List<Post> posts = [];
    var jsonData = jsonDecode(response.body);

    for (var jsonPost in jsonData) {
      posts.add(Post.fromJson(jsonPost));
    }

    return posts;
  }

  void _post() async {
    String url = baseUrl + '\posts';

    var response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: jsonEncode({
          "userId": 20,
          "id": null,
          "title": "Teste",
          "body": "Corpo de exemplo"
        }));

    print(response.statusCode.toString());
    print(response.body);
  }

  void _patch() async {
    String url = baseUrl + '/posts/1';

    var response = await http.patch(Uri.parse(url),
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: jsonEncode({
          "userId": 20,
          "id": null,
          "title": "Teste",
          "body": "Corpo de exemplo"
        }));

    print(response.statusCode.toString());
    print(response.body);
  }

  void _put() async {
    String url = baseUrl + '/posts/1';

    var response = await http.put(Uri.parse(url),
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: jsonEncode({
          "userId": 20,
          "id": null,
          "title": "Teste",
          "body": "Corpo de exemplo"
        }));

    print(response.statusCode.toString());
    print(response.body);
  }

  
  void delete() async {
    String url = baseUrl + '/posts/1';

    var response = await http.delete(Uri.parse(url));

    print(response.statusCode.toString());
    print(response.body);
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Posts"),
          backgroundColor: Colors.pink,
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: _post, child: Text("Salvar")),
                    ElevatedButton(onPressed: _put, child: Text("Atualizar")),
                    ElevatedButton(onPressed: delete, child: Text("Deletar"))
                  ],
                ),
                FutureBuilder(
                    future: getPosts(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                          break;
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            print("Erro ao carregar!");
                          } else {
                            List<Post>? posts = snapshot.data;

                            return Expanded(
                                flex: 2,
                                child: ListView.builder(
                                  itemCount: posts!.length,
                                  itemBuilder: (context, index) {
                                    Post post = posts[index];
                                    return ListTile(
                                      title: Text(post.title),
                                      subtitle: Text(post.userId.toString()),
                                      leading: Text(post.id.toString()),
                                    );
                                  },
                                ));
                          }
                          break;
                      }
                      return Text("Sem Carregamento");
                    })
              ],
            )));
  }
}
