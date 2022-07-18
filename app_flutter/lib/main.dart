import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'store.dart';
import 'cadastro.dart';
import 'request.dart';
import 'game.dart';
import 'shopping_cart.dart';
import 'splash_screen.dart';
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
            initialRoute: SplashScreen.rota, // Começa nessa tela e depois navega para o login ou para a loja
            routes:
            {
                LoginPage.rota : (context) => LoginPage(),
                SplashScreen.rota : (context) => SplashScreen(),
                StorePage.rota: (context) => StorePage(),
                RegisterPage.rota: (context) => RegisterPage(),
                GamePage.rota: (context) => GamePage(),
                ShoppingCartPage.rota: (context) => ShoppingCartPage(),
            }
        );
    }
}

