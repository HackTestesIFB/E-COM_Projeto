import 'package:flutter/material.dart';
import 'request.dart';
import 'dart:convert';
import 'login.dart';
import 'game.dart';
import 'functions_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCartPage extends StatefulWidget
{
    const ShoppingCartPage({Key? key}) : super(key: key);
    static const rota = '/shopping_cart';

    @override
    State<ShoppingCartPage> createState() => ShoppingCartPageState();
}

class ShoppingCartPageState extends State<ShoppingCartPage>
{
    var carrinho = [];
    int total = 0;

    void initState()
    {
        this.atualizaCarrinho();
    }

    void atualizaCarrinho()
    {
        listasCarrinho().then((resposta)
        {
            setState(()
            {
                print('Carrinho: ${resposta.body}');

                this.carrinho = json.decode(resposta.body);

                if(carrinho != null)
                {
                    total = 0;
                    this.carrinho.forEach((current)
                    {
                        //this.total += int.parse(current['precoProduto']);
                        total = total + current["precoProduto"] as int;
                        print('Value:${current["precoProduto"]},  Type: ${current["precoProduto"].runtimeType}');
                    });
                }
                else
                {
                    total = 0;
                }
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
                title: const Text('Carrinho'),
            ),

            /*floatingActionButton: FloatingActionButton
            (
                heroTag: null,
                onPressed: () async
                {
                    logout();

                    Navigator.pushNamedAndRemoveUntil(context, LoginPage.rota, (route) => false);
                },
                child: Icon(Icons.logout_rounded),
            ),*/

            body: Column
            (
                children:
                [
                    Padding
                    (
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: ElevatedButton
                        (
                            onPressed: () async
                            {
                                dynamic resposta_compras = await aceitarComprasCarrinho();

                                dynamic resgatar_compras = await verCompras();

                                print('resposta_compras-> Body: {${resposta_compras.body}}, Status code: ${resposta_compras.statusCode} \n\nresgatar_compras-> Body: {${resgatar_compras.body}}, Status code: ${resgatar_compras.statusCode}');

                                atualizaCarrinho();
                            },

                            child: const Text('Aceitar todas as compras', style: TextStyle(fontSize: 20)),
                            style: ElevatedButton.styleFrom
                            (
                                primary: Colors.green,
                            ),
                        ),
                    ),

                    Padding
                    (
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: Text('Total: R\$${total}', style: TextStyle(fontSize: 25)),
                    ),

                    Expanded
                    (
                        child: ListView.builder
                        (
                            itemCount : carrinho.length,
                            itemBuilder: (context, index)
                            {
                                return ListTile
                                (
                                    title: Padding
                                    (
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                        child: Text
                                        (
                                            'R\$${carrinho[index]['precoProduto']} - ' + carrinho[index]['idProduto'],
                                            style: const TextStyle
                                            (
                                                fontSize: 20,
                                                color: Colors.black
                                            )
                                        ),
                                    ),

                                    trailing: FloatingActionButton
                                    (
                                        heroTag: null,
                                        child: Icon(Icons.remove_shopping_cart),
                                        onPressed: ()
                                        {
                                            retirarItemCarrinho(carrinho[index]['idProduto']).then((response)
                                            {
                                                dynamic resultado = response;
                                                print('Resultado = ${resultado.body}');

                                                this.atualizaCarrinho();
                                            });
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

