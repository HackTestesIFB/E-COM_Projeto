import 'package:flutter/material.dart';
import 'dart:convert';
import 'store.dart';
import 'cadastro.dart';
import 'request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget
{
    static const rota = '/login';

    @override
    createState()
    {
        return LoginPageState();
    }
}

class LoginPageState extends State<LoginPage>
{
    final TextEditingController _email = TextEditingController();
    final TextEditingController _senha = TextEditingController();

    @override
    Widget build(BuildContext context)
    {
        return Scaffold
        (
            appBar: AppBar(title: const Text('Login')),
            body: Column
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                [
                    // Campo de email
                    Padding
                    (
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField
                        (
                            controller: _email,
                            decoration: const InputDecoration
                            (
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                            ),
                        ),
                    ),

                    // Campo de senha
                    Padding
                    (
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField
                        (
                            controller: _senha,
                            obscureText: true,
                            decoration: const InputDecoration
                            (
                                border: OutlineInputBorder(),
                                labelText: 'Senha',
                            ),
                        ),
                    ),

                    Row
                    (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                        [
                            // Login
                            Padding
                            (
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: ElevatedButton
                                (
                                    onPressed: () async
                                    {
                                        dynamic response = await loginUsusario(_email.text, _senha.text);

                                        print('${_email.text}, ${_senha.text}, ${response.statusCode}, ${response.body}');

                                        if(response.statusCode == 200)
                                        {
                                            var resposta = json.decode(response.body)['usuario'];

                                            final prefs = await SharedPreferences.getInstance();
                                            await prefs.setString('email', _email.text);
                                            await prefs.setString('senha', _senha.text);
                                            await prefs.setString('id_usuario', resposta['_id']);

                                            Navigator.pushReplacementNamed(context, StorePage.rota); // Não faz sentido ter como voltar ao login, sem que seja pelo logout
                                        }

                                        else
                                        {
                                            showDialog
                                            (
                                                context: context,
                                                builder: (BuildContext context)
                                                {
                                                    return AlertDialog
                                                    (
                                                        title: Text('Senha ou email incorretos'),
                                                        content: Text('Tente novamente por favor'),
                                                    );
                                                }
                                            );
                                        }
                                    },
                                    child: const Text('Login', style: TextStyle(fontSize: 20)),
                                ),
                            ),

                            // Cadastro
                            Padding
                            (
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: ElevatedButton
                                (
                                    onPressed: ()
                                    {
                                        Navigator.pushNamed(context, RegisterPage.rota);
                                    },
                                    child: const Text('Cadastrar nova conta', style: TextStyle(fontSize: 20)),
                                ),
                            ),
                        ],
                    ),

                ],
            )
        );
    }


    @override
    void dispose()
    {
        super.dispose();
        _email.dispose();
        _senha.dispose();
    }

}