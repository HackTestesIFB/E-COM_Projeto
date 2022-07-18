import 'package:flutter/material.dart';
import 'request.dart';
import 'dart:convert';
import 'login.dart';
import 'store.dart';
import 'functions_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> LoadLoginOrStore(BuildContext context) async
{
    // Simula um pequeno atraso da rede
    Future.delayed(Duration(seconds: 3),()
    {
        // Verica se usuário está com o login salvo
        SharedPreferences.getInstance().then((prefs) async
        {
            final String? email_salvo = prefs.getString('email');
            final String? senha_salva = prefs.getString('senha');

            // Tratamento para valores nulos
            if(email_salvo != null || senha_salva != null)
            {
                dynamic response = await loginUsusario(email_salvo!, senha_salva!);

                if(response.statusCode == 200)
                {
                    // Evita problemas com um id salvo anteriormente
                    await prefs.setString('id_usuario', json.decode(response.body)['usuario']['_id']);
                    print('Usuário logado: ${response.statusCode}, ${response.body}');

                    // Autenticado com sucesso
                    Navigator.pushReplacementNamed(context, StorePage.rota);
                }
                else
                {
                    // Possui login salvo, mas não é válido
                    Navigator.pushReplacementNamed(context, LoginPage.rota);
                    print('Usuário não possui login válido salvo');
                }
            }
            else
            {
                // Não existe um login salvo
                Navigator.pushReplacementNamed(context, LoginPage.rota);
                print('Usuário não possui login salvo');
            }
        });
    });
}

// Página inicial de carregamento
class SplashScreen extends StatelessWidget
{
    static const rota = '/spash_screen';

    @override
    Widget build(BuildContext context)
    {
        LoadLoginOrStore(context);

        return Material
        (
            child: Align
            (
                alignment: Alignment.center,
                child: SizedBox
                (
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(strokeWidth: 15),
                ) 
            )
            
        );
    }
}