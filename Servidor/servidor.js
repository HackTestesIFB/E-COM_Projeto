#!/usr/bin/node --unhandled-rejections=strict

// Bibliotecas necessárias
const cors = require('cors');
const express = require('express');
const fs = require('fs');
const util = require('util');
const mongoose = require('mongoose');
const Usuario = require('./models/Usuario');

// Configura o ExpressJS
const app = express();
app.use(cors());
app.use(express.json());

// conexão com o banco de dados
const dbURI = "mongodb://localhost:27017/ecom";
mongoose.connect(dbURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then((result) => { console.log('Conexão estabelecida com o banco de dados.\n'); })
  .catch((err) => console.log(err));

// Cria um objeto JS a partir dos parâmetros
// Atualizar os objetos fica mais fácil, pois só precisa alterar aqui
function criaEntradaJogos(nome, descricao, imagem_link, valor)
{
    return {'Nome': nome, 'Descricao': descricao, 'Imagem_capa': imagem_link, 'Valor': valor}
}

// Lista de objetos --> posteriormente podemos utilizar um HashMap para facilitar as consultas (HashMap --> array)
jogos =
[
    criaEntradaJogos('Halo: The Master Chief Collection', 'A lendária jornada do Master Chief está incluída em seis jogos, feitos para PC e reunidos em uma única experiência. Tanto para fãs de longa data como para os que conhecerão o Spartan 117 agora, a Master Chief Collection é a experiência de jogo definitiva da série Halo.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/976730/header.jpg?t=1649955774', 75.0),

    criaEntradaJogos('Counter-Strike: Global Offensive', 'O Counter-Strike: Global Offensive (CS:GO) melhora a jogabilidade de ação baseada em equipes na qual foi pioneiro quando lançado há 19 anos. O CS:GO contém novos mapas, personagens e armas, além de contar com versões atualizadas de conteúdos do CS clássico (como de_dust2).', 'https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg?t=1641233427', 99.0),

    criaEntradaJogos('Half-Life: Alyx', 'Half-Life: Alyx é a volta da Valve à série Half-Life em realidade virtual. Trata-se da história de uma impossível luta contra uma raça alienígena cruel, conhecida como Combine, situada entre os eventos de Half-Life e Half-Life 2.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/546560/header.jpg?t=1641577012', 199.0),

    criaEntradaJogos('Batman™: Arkham Knight', 'Batman™: Arkham Knight é a conclusão épica da trilogia Arkham da Rocksteady Studios. Desenvolvido exclusivamente para plataformas de última geração, Batman™: Arkham Knight apresenta o design exclusivo da Rocksteady para o Batmóvel.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/208650/header.jpg?t=1634156452', 250.0),

    criaEntradaJogos('Grand Theft Auto V', 'Grand Theft Auto V para PC oferece aos jogadores a opção de explorar o gigantesco e premiado mundo de Los Santos e Blaine County em resoluções de até 4K e além, assim como a chance de experimentar o jogo rodando a 60 FPS (quadros por segundo).', 'https://cdn.cloudflare.steamstatic.com/steam/apps/271590/header.jpg?t=1618856444', 120.0),

    criaEntradaJogos('Grand Theft Auto IV: The Complete Edition', 'Niko Bellic, Johnny Klebitz e Luis Lopez têm uma coisa em comum: eles vivem na pior cidade da América do Norte. Liberty City cultua dinheiro e status, e é o paraíso para quem tem essas coisas, mas um pesadelo para quem não tem.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/12210/header.jpg?t=1618853493', 99.0),

    criaEntradaJogos('Ready or Not', 'Ready or Not é um jogo de tiro em primeira pessoa, intenso, tático e atual. Nele, as unidades policiais da SWAT são chamadas para controlar situações de hostilidade e de confronto.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/1144200/header.jpg?t=1655539544', 50.0),
]

// Envia todos os jogos da loja
app.get('/getJogos', async (req, res) =>
{
    console.log('Get - /getJogos');
    try
    {
        res.json
        ({
            Status: 'OK',
            Jogos: jogos,
        })
    }

    catch(error)
    {
        res.json
        ({
            Status: 'ERROR',
            Erro: error
        });
    }
});

// Recebe um pedido de compra e retorna a confirmação
app.post('/realizarCompra', async (req, res) =>
{
    console.log('Post - /realizarCompra', req.body);
    try
    {
        res.json
        ({
            Status: 'OK',
            Descricao: 'Compra realizada',
            Requisicao: req.body
        })
    }

    catch(error)
    {
        res.json
        ({
            Status: 'ERROR',
            Descricao: 'Compra falhou',
            Requisicao: req.body,
            Erro: error
        });
    }
});

// Cadastro e Login
app.post('/cadastroUsuario', async (req, res) => {
    const { email, senha } = req.body;
    try {
        const usuario = await Usuario.create({ email, senha });
        console.log(`Cadastro realizado com sucesso.: ${email}; ${senha}`);
        res.status(201).json(usuario._id);
    } catch(err) {
        console.log(err);
        res.status(400).json({err});
    }
});

app.post('/loginUsuario', async (req, res) => {
  const { email, senha } = req.body;
  try {
    const usuario = await Usuario.login(email, senha);
    res.status(200).json({usuario: usuario});
  } catch(err) {
    res.status(400).json({err});
  }
});

// Inicializa o servidor na porta especificada
port_listen = 8000;
app.listen(port_listen, () =>
{
    console.log(`Server: OK \nPort: ${port_listen} \n`);
    console.log(`http://127.0.0.1:${port_listen}\n`);
});