import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Faz uma requisição ao servidor para retornar todos os jogos na loja
Future listarJogos() async
{
    return await http.get(Uri.http('localhost:8000', '/GetJogos'));
}

// Envia uma requisição de compra
Future comprarJogos(String nome_do_jogo) async
{
    return await http.post(Uri.http('localhost:8000', '/RealizarCompra'), headers: {"Content-Type": "application/json"}, body: json.encode({'Nome': '$nome_do_jogo'}));
}

// Envia uma requisição de compra
Future cadastrarUsusario(String email, String senha) async
{
    return await http.post(Uri.http('localhost:8000', '/cadastroUsuario'), headers: {"Content-Type": "application/json"}, body: json.encode({'email': '$email', 'senha': '$email'}));
}

// Envia uma requisição de compra
Future loginUsusario(String email, String senha) async
{
    return await http.post(Uri.http('localhost:8000', '/loginUsuario'), headers: {"Content-Type": "application/json"}, body: json.encode({'email': '$email', 'senha': '$email'}));
}

Future adicionaAoCarrinho(String nome_jogo, int quantidade) async
{
    final prefs = await SharedPreferences.getInstance();
    String? id_usuario = prefs.getString('id_usuario');

    return await http.post(Uri.http('localhost:8000', '/postCarrinho'), headers: {"Content-Type": "application/json"}, body: json.encode({'idUsuario': '$id_usuario', 'idProduto': '$nome_jogo', 'quantidade': '$quantidade'}));
}

Future retirarItemCarrinho(String nome_jogo) async
{
    final prefs = await SharedPreferences.getInstance();
    String? id_usuario = prefs.getString('id_usuario');

    return await http.post(Uri.http('localhost:8000', '/deleteItemCarrinho'), headers: {"Content-Type": "application/json"}, body: json.encode({'idUsuario': '$id_usuario', 'idProduto': '$nome_jogo'}));
}

//
Future listasCarrinho() async
{
    final prefs = await SharedPreferences.getInstance();
    String? id_usuario = prefs.getString('id_usuario');

    return await http.post(Uri.http('localhost:8000', '/getCarrinho'), headers: {"Content-Type": "application/json"}, body: json.encode({'idUsuario': '$id_usuario'}));
}

Future aceitarComprasCarrinho() async
{
    final prefs = await SharedPreferences.getInstance();
    String? id_usuario = prefs.getString('id_usuario');

    return await http.post(Uri.http('localhost:8000', '/postCompra'), headers: {"Content-Type": "application/json"}, body: json.encode({'idUsuario': '$id_usuario'}));
}

Future verCompras() async
{
    final prefs = await SharedPreferences.getInstance();
    String? id_usuario = prefs.getString('id_usuario');

    return await http.post(Uri.http('localhost:8000', '/getCompra'), headers: {"Content-Type": "application/json"}, body: json.encode({'idUsuario': '$id_usuario'}));
}