import 'package:flutter/material.dart';
import 'store.dart';
import 'cadastro.dart';

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
    final TextEditingController _telefone = TextEditingController();
    final TextEditingController _senha = TextEditingController();

    @override
    Widget build(BuildContext context)
    {
        return Material
        (
            child: Column
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                [
                    Padding
                    (
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField
                        (
                            controller: _telefone,
                            decoration: const InputDecoration
                            (
                                border: OutlineInputBorder(),
                                labelText: 'Telefone',
                            ),
                        ),
                    ),

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
                            Padding
                            (
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: ElevatedButton
                                (
                                    onPressed: ()
                                    {
                                        setState(()
                                        {
                                            print('${_telefone.text}, ${_senha.text}');

                                            if(_telefone.text == '1234' && _senha.text == 'senha')
                                            {
                                                Navigator.pushNamed(context, HomePage.rota);
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
                                                            title: Text('Senha ou telefone incorretos'),
                                                            content: Text('Tente novamente por favor'),
                                                        );
                                                    }
                                                );
                                            }
                                        });
                                    },
                                    child: const Text('Login', style: TextStyle(fontSize: 20)),
                                ),
                            ),

                            Padding
                            (
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: ElevatedButton
                                (
                                    onPressed: ()
                                    {
                                        setState(()
                                        {
                                            print('${_telefone.text}, ${_senha.text}');
                                            Navigator.pushNamed(context, RegisterPage.rota);
                                        });
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
        _telefone.dispose();
        _senha.dispose();
    }

}