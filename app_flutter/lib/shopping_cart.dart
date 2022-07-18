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
    double total = 0;

    void initState()
    {
        this.atualizaCarrinho();
    }

    // Função que atualiza a interface do carrinho
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
                        total = total + current["precoProduto"] as double; // Conversão para um valor que dê para somar
                    });
                }
                // Carrinho é vazio ou não existe
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

            body: Column
            (
                children:
                [
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
                                        child: Row
                                        (
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children:
                                            [
                                                Flexible
                                                (
                                                    child: Text
                                                    (
                                                        carrinho[index]['idProduto'],
                                                        style: const TextStyle
                                                        (
                                                            fontSize: 20,
                                                            color: Colors.black
                                                        )
                                                    ),
                                                ),

                                                Text
                                                (
                                                    'R\$${carrinho[index]['precoProduto'].toDouble()}',
                                                    style: const TextStyle
                                                    (
                                                        fontSize: 20,
                                                        color: Colors.black
                                                    )
                                                ),
                                            ],
                                        ),
                                    ),

                                    // Botão para retirar do carrinho
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

                                // Compra realizada com sucesso
                                if(resposta_compras.statusCode == 201)
                                {
                                    showDialog
                                    (
                                        context: context,
                                        builder: (BuildContext context)
                                        {
                                            return AlertDialog
                                            (
                                                title: Text('Sucesso!'),
                                                content: Text('Compra realizada!!!'),
                                            );
                                        }
                                    );
                                }

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

                ],
            ),
        );
    }
}

