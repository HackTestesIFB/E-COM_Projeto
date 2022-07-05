import 'package:flutter/material.dart';
import 'request.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget
{
    const HomePage({Key? key}) : super(key: key); // Necessário para utilizar o const
    static const rota = '/store';

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
            child: Column
            (
                children:
                [
                    Expanded
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
                        ),
                    ),

                    Padding
                    (
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: ElevatedButton
                        (
                            onPressed: () async
                            {
                                final prefs = await SharedPreferences.getInstance();

                                await prefs.remove('email');
                                await prefs.remove('senha');

                                Navigator.pop(context);
                            },
                            child: const Text('Logout', style: TextStyle(fontSize: 20)),
                        ),
                    ),
                ],
            ),
        );
    }
}

