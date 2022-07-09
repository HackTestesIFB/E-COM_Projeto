import 'package:flutter/material.dart';
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

    LoginPageState()
    {
        // Verica se usuário está com o login salvo
        SharedPreferences.getInstance().then((prefs) async
        {
            final String? email_salvo = prefs.getString('email');
            final String? senha_salva = prefs.getString('senha');

            if(email_salvo != null || senha_salva != null)
            {
                dynamic response = await loginUsusario(email_salvo!, senha_salva!);

                if(response.statusCode == 200)
                {
                    print('Usuário logado: ${response.statusCode}, ${response.body}');
                    Navigator.pushReplacementNamed(context, StorePage.rota);
                }
            }
            else
            {
                print('Usuário não possui login salvo');
            }
        });
    }

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
                                        dynamic response = await loginUsusario(_email.text, _senha.text);

                                        print('${_email.text}, ${_senha.text}, ${response.statusCode}, ${response.body}');

                                        if(response.statusCode == 200)
                                        {
                                            final prefs = await SharedPreferences.getInstance();
                                            await prefs.setString('email', _email.text);
                                            await prefs.setString('senha', _senha.text);

                                            Navigator.pushReplacementNamed(context, StorePage.rota);
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