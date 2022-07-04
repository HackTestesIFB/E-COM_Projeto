import 'dart:convert';
import 'package:http/http.dart' as http;

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