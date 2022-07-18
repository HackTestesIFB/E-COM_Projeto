import 'package:flutter/material.dart';
import 'request.dart';
import 'dart:convert';
import 'login.dart';
import 'game.dart';
import 'shopping_cart.dart';
import 'functions_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class StorePage extends StatefulWidget
{
    const StorePage({Key? key}) : super(key: key); // Necessário para utilizar o const
    static const rota = '/store';

    @override
    State<StorePage> createState() => StorePageState();
}

class StorePageState extends State<StorePage>
{
    var jogos=[];

    void initState()
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
        return Scaffold
        (
            appBar: AppBar
            (
                title: const Text('Loja de jogos'),

                actions:
                [
                    // Botão do carrinho
                    Padding
                    (
                        padding: EdgeInsets.only(right: 30.0),
                        child: GestureDetector
                        (
                            onTap:() async
                            {
                                Navigator.pushNamed(context, ShoppingCartPage.rota);

                            },
                            child: Icon
                            (
                                Icons.shopping_cart,
                                size: 26.0,
                            ),
                        )
                    ),
                ]
            ),

            floatingActionButton: FloatingActionButton
            (
                heroTag: null,
                onPressed: () async
                {
                    logout();

                    // Remove todas as telas e navega para o login
                    Navigator.pushNamedAndRemoveUntil(context, LoginPage.rota, (route) => false);
                },
                child: Icon(Icons.logout_rounded),
            ),

            body: Column
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

                                    // Botão para acessar os detalhes do jogo
                                    trailing: FloatingActionButton
                                    (
                                        heroTag: null,
                                        child: Icon(Icons.add_shopping_cart),
                                        onPressed: ()
                                        {
                                            Navigator.pushNamed(context, GamePage.rota, arguments: {'Jogo': jogos[index]});
                                        }
                                    )
                                );
                            },
                        ),
                    ),

                    SizedBox(height: 75),
                ],
            ),
        );
    }
}

