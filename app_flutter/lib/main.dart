import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

var url = http.get(Uri.http('127.0.0.1:8000', '/GetJogos'));

Future listarJogos() async
{
    return await http.get(Uri.http('localhost:8000', '/GetJogos'));
}

Future comprarJogos(String nome_do_jogo) async
{
    return await http.post(Uri.http('localhost:8000', '/RealizarCompra'), headers: {"Content-Type": "application/json"}, body: json.encode({'Nome': '$nome_do_jogo'}));
}

class Jogo
{
    final String _nome;
    final String _descricao;
    final String _foto;
    final double _valor;

    String get nome => _nome;
    String get descricao => _descricao;
    String get foto => _foto;
    double get valor => _valor;

    Jogo( this._nome, this._descricao, this._foto, this._valor);

    Jogo.fromJson(Map json) : _nome=json['Nome'], _descricao=json['Descricao'], _foto=json['Imagem_capa'], _valor=json['Valor'];
}

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget
{
    const MeuApp({Key? key}) : super(key: key);

    @override
    build(context)
    {
        return const MaterialApp
        (
            title: 'Loja de jogos',
            home: HomePage(),
        );
    }
}

class HomePage extends StatefulWidget 
{
    const HomePage({Key? key}) : super(key: key);

    @override
    State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{
  var jogos=[];
 
    HomePageState()
    {
        listarJogos().then((response)
        {
            setState(()
            {
                Iterable lista = json.decode(response.body)['Jogos'];
                jogos = json.decode(response.body)['Jogos'];// lista.map((model) => Jogo.fromJson(model)).toList();
            });
        });
    }
  
    @override
    Widget build(BuildContext context)
    {
        return Material
        (
            child: ListView.builder
            (
                itemCount : jogos.length,
                itemBuilder: (context, index)
                {
                    return ListTile
                    (
                        title: Text
                        (
                            jogos[index]['Nome'],
                            style: const TextStyle
                            (
                                fontSize: 20,
                                color: Colors.black
                            )
                        ),

                        subtitle: Text(jogos[index]['Descricao'].toString().substring(0, 30)+'...'),

                        trailing: FloatingActionButton
                        (
                            child: Icon(Icons.add_shopping_cart),
                            onPressed: ()
                            {
                                comprarJogos(jogos[index]['Nome']).then((response)
                                {
                                    dynamic resultado = response.body;
                                    print('Resultado = ${resultado}');
                                });
                            }
                        )
                    );
                },
            )
        );
    }
}