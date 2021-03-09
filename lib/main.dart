import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:encrypt/encrypt.dart' as encrypt;

import 'Models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Teste',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Página Principal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

String token;

class Mapeando {
  String user;
  String token;

  Mapeando(this.user,this.token);

  Mapeando.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        token = json['token'];
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<user> lUser = new List<user>();
  List<Mapeando> lMap = [];
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();

  String encriptaSenha(String senha){
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(senha, iv: iv);

    return encrypted.base64.toString();
  }

  String dencriptaSenha(String senhaEncriptada){
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final teste = encrypter.decrypt64(senhaEncriptada, iv: iv);

    return teste;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[700],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                child: TextField(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0),
                    labelText: "Nome Usuário",
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        )),
                    filled: true,
                    fillColor: Colors.blueGrey[400],
                  ),
                  controller: usuarioController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                child: TextField(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0),
                    labelText: "Senha",
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        )),
                    filled: true,
                    fillColor: Colors.blueGrey[400],
                  ),
                  controller: senhaController,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.only(
                  left: 45.0,
                  top: 20.0,
                  right: 45.0,
                  bottom: 20.0,
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.blueAccent[400],
                child: new Text(
                  "Executar",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () async {
                  print("Usando de senha condificada");
                  String ret = encriptaSenha(senhaController.text);
                  print(ret);
                  print("---------------------------");
                  print("Senha decodificada");
                  print(dencriptaSenha(ret));
                  print("---------------------------");
                  var body =
                    {
                      "id": 0,
                      "username": "robin",
                      "password": "robin",
                      "role": "string"
                    }
                  ;
                  print(body);
                  String alterado = json.encode(body);
                  print("Valor de alterado");
                  print(alterado);
                  //String link = "http://192.168.0.115:11295/WeatherForecast/login";
                  Map<String, String> headers = new Map<String, String>();
                  headers['Content-type'] = "application/json";
                  headers['Accept'] = "Application/json";
                  String link = "http://localhost:11295/WeatherForecast/login";
                  Uri uriLink = Uri.parse(link);
                  http.Response resp = await http.post(uriLink,
                      headers: headers,
                    body: alterado
                  ); //'https://192.168.0.115:11295/WeatherForecast/login' , headers: headers);
                  print("Voltou");
                    print(resp.body);

                    var Valores = json.decode(resp.body);

                    Map<String, dynamic> map = json.decode(resp.body);
                    try {
                      String msg = map['message'];
                      if(msg.length>0){
                        print("Nâo Autorizado!");
                      }
                    }
                    catch(e){
                      var resp1 = map['user'];
                      user resp4 = user.fromJson(resp1);

                      token = (map['token']).toString();
                      print("Autorizado!");
                    }

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
