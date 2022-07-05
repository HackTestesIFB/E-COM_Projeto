import 'package:flutter/material.dart';
import 'store.dart';
import 'request.dart';

class RegisterPage extends StatefulWidget
{
    static const rota = '/register';

    @override
    createState()
    {
        return RegisterPagePageState();
    }
}

class RegisterPagePageState extends State<RegisterPage>
{
    //final TextEditingController _nome_completo = TextEditingController();
    final TextEditingController _email = TextEditingController();
    //final TextEditingController _telefone = TextEditingController();
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
                    /*Padding
                    (
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField
                        (
                            controller: _nome_completo,
                            decoration: const InputDecoration
                            (
                                border: OutlineInputBorder(),
                                labelText: 'Nome completo',
                            ),
                        ),
                    ),*/

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

                    /*Padding
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
                    ),*/

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
                                    onPressed: () async
                                    {
                                        dynamic response = await cadastrarUsusario(_email.text, _senha.text);

                                        setState(()
                                        {
                                            print('${_email.text}, ${_senha.text}, ${response.statusCode}, ${response.body}');  

                                            // Cadastro feito com sucesso
                                            if(response.statusCode == 201)
                                            {
                                                Navigator.pop(context);
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
                                                            title: Text('Usuário já existe'),
                                                            content: Text('Tente novamente um número de telefone diferente por favor'),
                                                        );
                                                    }
                                                );
                                            }
                                        });
                                    },
                                    child: const Text('Cadastrar agora', style: TextStyle(fontSize: 20)),
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