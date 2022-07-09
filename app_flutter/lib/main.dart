import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'store.dart';
import 'cadastro.dart';
import 'request.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Inicializa o app
Future<void> main() async
{
    runApp(const MeuApp());
}

// App principal
class MeuApp extends StatelessWidget
{
    const MeuApp({Key? key}) : super(key: key); // Necessário para utilizar o const

    @override
    build(context)
    {
        return MaterialApp
        (
            title: 'Loja de jogos',
            initialRoute: LoginPage.rota,
            routes:
            {
                LoginPage.rota : (context) => LoginPage(),
                StorePage.rota: (context) => StorePage(),
                RegisterPage.rota: (context) => RegisterPage(),
            }
        );
    }
}

