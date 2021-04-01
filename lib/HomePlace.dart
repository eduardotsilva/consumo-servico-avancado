import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'Post.dart';

class HomePlace extends StatefulWidget {
  @override
  _HomePlaceState createState() => _HomePlaceState();
}

class _HomePlaceState extends State<HomePlace> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(_urlBase + "/posts");
    var dadosJson = json.decode(response.body);
    List<Post> postagens = List();

    for (var post in dadosJson) {
      print("post: " + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }

    return postagens;
  }

  _post() async {
    var corpo = json.encode({
      "userId": 1990,
      "id": null,
      "title": "Título",
      "body": "Corpo da Postagem"
    });

    http.Response response = await http.post(_urlBase + "/posts",
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: corpo);

    print("resposta:  ${response.statusCode}");
    print("resposta:  ${response.body}");
  }

  _put() {}

  _patch() {}

  _delete() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                RaisedButton(
                  onPressed: _post,
                  child: Text("Salvar"),
                ),
                RaisedButton(
                  onPressed: _post,
                  child: Text("Atualizar"),
                ),
                RaisedButton(
                  onPressed: _post,
                  child: Text("Remover"),
                ),
              ],
            ),
            Expanded(
                child: FutureBuilder<List<Post>>(
              future: _recuperarPostagens(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      print("lista: Erro ao carregar");
                    } else {
                      print("lista: Erro ao carregou");
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List<Post> lista = snapshot.data;
                            Post post = lista[index];

                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.id.toString()),
                            );
                          });
                    }
                    break;
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.active:
                }
                return Center(
                  child: Text(""),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
