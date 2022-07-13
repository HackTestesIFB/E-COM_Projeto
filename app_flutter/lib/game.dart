import 'package:flutter/material.dart';
import 'request.dart';
import 'dart:convert';
import 'login.dart';
import 'store.dart';
import 'functions_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class GamePage extends StatelessWidget
{
    static const rota = '/game';

    @override
    Widget build(BuildContext context)
    {
        var jogo = Map.from(ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>)['Jogo'];
        String titulo = jogo['Nome'];
        String descricao = jogo['Descricao'];
        String imagem_link = jogo['Imagem_capa'];
        int preco = jogo['Valor'];

        return Scaffold
        (
            appBar: AppBar
            (
                title: Text(titulo),
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
                    Image( image: NetworkImage(imagem_link)),

                    Text(titulo, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),

                    Divider(color: Colors.black),

                    Padding
                    (
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: Text('\t' + descricao, style: TextStyle(fontSize: 15), textAlign: TextAlign.justify),
                    ),

                    Padding
                    (
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: ElevatedButton
                        (
                            onPressed: ()
                            {
                                adicionaAoCarrinho(titulo, 1);
                                Navigator.pop(context);
                            },
                            child: Text('Adicionar ao carrinho - R\$${preco}', style: TextStyle(fontSize: 20)),
                        ),
                    ),
                ],
            ),
        );
    }
}