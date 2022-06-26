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
                jogos = json.decode(response.body)['Jogos'];
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