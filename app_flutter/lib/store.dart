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
                    Padding
                    (
                        padding: EdgeInsets.only(right: 30.0),
                        child: GestureDetector
                        (
                            onTap:() async
                            {
                                dynamic carrinho = await listasCarrinho();

                                listasCarrinho().then((resposta)
                                {
                                    print('Carrinho: ${resposta.body}');

                                    var jogos_carrinho = json.decode(resposta.body);
                                    Navigator.pushNamed(context, ShoppingCartPage.rota, arguments :{'Carrinho': jogos_carrinho});
                                });
                                
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

                                    trailing: FloatingActionButton
                                    (
                                        heroTag: null,
                                        child: Icon(Icons.add_shopping_cart),
                                        onPressed: ()
                                        {
                                            /*// Comprar jogos utiliza o nome do jogo
                                            comprarJogos(jogos[index]['Nome']).then((response)
                                            {
                                                dynamic resultado = response.body;
                                                print('Resultado = ${resultado}');
                                            });
                                            */

                                            Navigator.pushNamed(context, GamePage.rota, arguments: {'Jogo': jogos[index]});
                                        }
                                    )
                                );
                            },
                        ),
                    ),
                ],
            ),
        );
    }
}

