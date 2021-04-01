import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> _recuperarPreco() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (context, snapshot) {
        String _resultado;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.done:
            if (snapshot.hasError){
              _resultado = "Erro ao carregar os dados";
            }else{
              double valor = snapshot.data["BRL"]["buy"];
              _resultado = "Preço do bitcoin: ${valor.toString()}";
            }
            break;
          case ConnectionState.waiting:
            _resultado = "Carregando...";
            break;
          case ConnectionState.active:
        }
        return Center(
          child: Text(_resultado),
        );
      },
    );
  }
}
