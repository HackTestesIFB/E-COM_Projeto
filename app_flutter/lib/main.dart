import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


// Faz uma requisição ao servidor para retornar todos os jogos na loja
Future listarJogos() async
{
    return await http.get(Uri.http('localhost:8000', '/GetJogos'));
}

// Envia uma requisição de compra
Future comprarJogos(String nome_do_jogo) async
{
    return await http.post(Uri.http('localhost:8000', '/RealizarCompra'), headers: {"Content-Type": "application/json"}, body: json.encode({'Nome': '$nome_do_jogo'}));
}

// Inicializa o app
void main() => runApp(const MeuApp());

// App principal
class MeuApp extends StatelessWidget
{
    const MeuApp({Key? key}) : super(key: key); // Necessário para utilizar o const

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
    const HomePage({Key? key}) : super(key: key); // Necessário para utilizar o const

    @override
    State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{
    var jogos=[];

    HomePageState()
    {
        // Recebe todos os jogos a passa a array contendo todos eles no JSON
        listarJogos().then((response)
        {
            setState(()
            {
                jogos = json.decode(response.body)['Jogos']; // Lista de hash maps
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

                        // Mostra apenas parte da descrição
                        subtitle: Text(jogos[index]['Descricao'].toString().substring(0, 40)+'...'),

                        trailing: FloatingActionButton
                        (
                            child: Icon(Icons.add_shopping_cart),
                            onPressed: ()
                            {
                                // Comprar jogos utiliza o nome do jogo
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