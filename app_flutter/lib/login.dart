import 'package:flutter/material.dart';
import 'store.dart';
import 'cadastro.dart';
import 'request.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future getEmailSenha() async
{
    final prefs = await SharedPreferences.getInstance();
    final String? email_salvo = prefs.getString('email');
    final String? senha_salva = prefs.getString('senha');

    if(email_salvo == null || senha_salva == null)
    {
        return {'email': email_salvo, 'senha': senha_salva};
    }

    return {'email': email_salvo, 'senha': senha_salva};
}

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
    void initState()
    {
        super.initState();
        final prefs = SharedPreferences.getInstance().then((prefs)
        {
            setState(()
            {
                final String? email_salvo = prefs.getString('email');
                final String? senha_salva = prefs.getString('senha');

                if(email_salvo != null || senha_salva != null)
                {
                    _email.text = email_salvo!;
                    _senha.text = senha_salva!;
                }

                print('${email_salvo}, ${senha_salva}');
            });
        });

    }

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
                                        print('${_email.text}, ${_senha.text}');
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