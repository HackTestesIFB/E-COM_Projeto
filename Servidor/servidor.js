#!/usr/bin/node --unhandled-rejections=strict

// Bibliotecas necessárias
const express = require('express');
const fs = require('fs');
const util = require('util');
const mongoose = require('mongoose');
const Usuario = require('./models/Usuario');
const Carrinho = require('./models/Carrinho');
const Compra = require('./models/Compra');

// Configura o ExpressJS
const app = express();
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
/*jogos =
[
    criaEntradaJogos('Halo: The Master Chief Collection', 'A lendária jornada do Master Chief está incluída em seis jogos, feitos para PC e reunidos em uma única experiência. Tanto para fãs de longa data como para os que conhecerão o Spartan 117 agora, a Master Chief Collection é a experiência de jogo definitiva da série Halo.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/976730/header.jpg?t=1649955774', 75.0),

    criaEntradaJogos('Counter-Strike: Global Offensive', 'O Counter-Strike: Global Offensive (CS:GO) melhora a jogabilidade de ação baseada em equipes na qual foi pioneiro quando lançado há 19 anos. O CS:GO contém novos mapas, personagens e armas, além de contar com versões atualizadas de conteúdos do CS clássico (como de_dust2).', 'https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg?t=1641233427', 99.0),

    criaEntradaJogos('Half-Life: Alyx', 'Half-Life: Alyx é a volta da Valve à série Half-Life em realidade virtual. Trata-se da história de uma impossível luta contra uma raça alienígena cruel, conhecida como Combine, situada entre os eventos de Half-Life e Half-Life 2.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/546560/header.jpg?t=1641577012', 199.0),

    criaEntradaJogos('Batman™: Arkham Knight', 'Batman™: Arkham Knight é a conclusão épica da trilogia Arkham da Rocksteady Studios. Desenvolvido exclusivamente para plataformas de última geração, Batman™: Arkham Knight apresenta o design exclusivo da Rocksteady para o Batmóvel.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/208650/header.jpg?t=1634156452', 250.0),

    criaEntradaJogos('Grand Theft Auto V', 'Grand Theft Auto V para PC oferece aos jogadores a opção de explorar o gigantesco e premiado mundo de Los Santos e Blaine County em resoluções de até 4K e além, assim como a chance de experimentar o jogo rodando a 60 FPS (quadros por segundo).', 'https://cdn.cloudflare.steamstatic.com/steam/apps/271590/header.jpg?t=1618856444', 120.0),

    criaEntradaJogos('Grand Theft Auto IV: The Complete Edition', 'Niko Bellic, Johnny Klebitz e Luis Lopez têm uma coisa em comum: eles vivem na pior cidade da América do Norte. Liberty City cultua dinheiro e status, e é o paraíso para quem tem essas coisas, mas um pesadelo para quem não tem.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/12210/header.jpg?t=1618853493', 99.0),

    criaEntradaJogos('Ready or Not', 'Ready or Not é um jogo de tiro em primeira pessoa, intenso, tático e atual. Nele, as unidades policiais da SWAT são chamadas para controlar situações de hostilidade e de confronto.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/1144200/header.jpg?t=1655539544', 50.0),
]*/

jogos = new Map();

    jogos.set('Halo: The Master Chief Collection', criaEntradaJogos('Halo: The Master Chief Collection', 'A lendária jornada do Master Chief está incluída em seis jogos, feitos para PC e reunidos em uma única experiência. Tanto para fãs de longa data como para os que conhecerão o Spartan 117 agora, a Master Chief Collection é a experiência de jogo definitiva da série Halo.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/976730/header.jpg?t=1649955774', 75.0));

    jogos.set('Counter-Strike: Global Offensive', criaEntradaJogos('Counter-Strike: Global Offensive', 'O Counter-Strike: Global Offensive (CS:GO) melhora a jogabilidade de ação baseada em equipes na qual foi pioneiro quando lançado há 19 anos. O CS:GO contém novos mapas, personagens e armas, além de contar com versões atualizadas de conteúdos do CS clássico (como de_dust2).', 'https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg?t=1641233427', 99.0));

    jogos.set('Half-Life: Alyx', criaEntradaJogos('Half-Life: Alyx', 'Half-Life: Alyx é a volta da Valve à série Half-Life em realidade virtual. Trata-se da história de uma impossível luta contra uma raça alienígena cruel, conhecida como Combine, situada entre os eventos de Half-Life e Half-Life 2.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/546560/header.jpg?t=1641577012', 199.0));

    jogos.set('Batman™: Arkham Knight', criaEntradaJogos('Batman™: Arkham Knight', 'Batman™: Arkham Knight é a conclusão épica da trilogia Arkham da Rocksteady Studios. Desenvolvido exclusivamente para plataformas de última geração, Batman™: Arkham Knight apresenta o design exclusivo da Rocksteady para o Batmóvel.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/208650/header.jpg?t=1634156452', 250.0));

    jogos.set('Grand Theft Auto V', criaEntradaJogos('Grand Theft Auto V', 'Grand Theft Auto V para PC oferece aos jogadores a opção de explorar o gigantesco e premiado mundo de Los Santos e Blaine County em resoluções de até 4K e além, assim como a chance de experimentar o jogo rodando a 60 FPS (quadros por segundo).', 'https://cdn.cloudflare.steamstatic.com/steam/apps/271590/header.jpg?t=1618856444', 120.0));

    jogos.set('Grand Theft Auto IV: The Complete Edition', criaEntradaJogos('Grand Theft Auto IV: The Complete Edition', 'Niko Bellic, Johnny Klebitz e Luis Lopez têm uma coisa em comum: eles vivem na pior cidade da América do Norte. Liberty City cultua dinheiro e status, e é o paraíso para quem tem essas coisas, mas um pesadelo para quem não tem.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/12210/header.jpg?t=1618853493', 99.0));

    jogos.set('Ready or Not', criaEntradaJogos('Ready or Not', 'Ready or Not é um jogo de tiro em primeira pessoa, intenso, tático e atual. Nele, as unidades policiais da SWAT são chamadas para controlar situações de hostilidade e de confronto.', 'https://cdn.cloudflare.steamstatic.com/steam/apps/1144200/header.jpg?t=1655539544', 50.0));


// Envia todos os jogos da loja
app.get('/getJogos', async (req, res) =>
{
    console.log('Get - /getJogos');
    try
    {
        res.json
        ({
            Status: 'OK',
            Jogos: [...jogos.values()],
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

// Cadastro e Login
app.post('/cadastroUsuario', async (req, res) => {
    console.log('Post - /cadastroUsuario');
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
    console.log('Post - /loginUsuario');
    const { email, senha } = req.body;
    try {
        const usuario = await Usuario.login(email, senha);
        res.status(200).json({usuario: usuario});
    } catch(err) {
        res.status(400).json({err});
    }
});

// Carrinho
app.post('/postCarrinho', async (req, res) => {
    console.log('Post - /postCarrinho');
    const { idUsuario, idProduto, quantidade } = req.body;
    try {
        let precoProduto = jogos.get(idProduto)['Valor'];
        const usuario = await Carrinho.create({ idUsuario, idProduto, precoProduto, quantidade });
        res.status(201).json({msg: 'Adicionado ao carrinho com sucesso.'});
    } catch(err) {
        console.log(err);
        res.status(400).json({err});
    }
});

app.post('/getCarrinho', async (req, res) => {
    console.log('Post - /getCarrinho');
    const { idUsuario } = req.body;
    try {
        const busca = await Carrinho.find({ idUsuario: idUsuario });
        res.status(201).json(busca);
    } catch(err) {
        console.log(err);
        res.status(400).json({err});
    }
});

app.post('/deleteItemCarrinho', async (req, res) => {
    console.log('Post - /deleteItemCarrinho');
    const { idProduto } = req.body;
    try {
        const res = await Carrinho.deleteOne({ idProduto: idProduto });
        res.status(201).json({itemDeletado: res});
    } catch(err) {
        console.log(err);
        res.status(400).json({err});
    }
});

// Compra
app.post('/postCompra', async (req, res) => {
    console.log('Post - /postCompra');
    const { idUsuario } = req.body;
    try {
        let busca = await Carrinho.find({ idUsuario: idUsuario }, { _id: 0 });
        busca = JSON.stringify(busca);
        const compra = await Compra.create({ idUsuario, busca});
        busca = await Carrinho.deleteMany({ idUsuario: idUsuario })
        res.status(201).json({msg: 'Compra realizada com sucesso.'});
    } catch(err) {
        console.log(err);
        res.status(400).json({err});
    }
});

app.post('/getCompra', async (req, res) => {
    console.log('Post - /getCompra');
    const { idUsuario } = req.body;
    try {
        const busca = await Compra.find({ _id: idUsuario });
        res.status(201).json(busca);
    } catch(err) {
        console.log(err);
        res.status(400).json({err});
    }
});

// Outros gets úteis
app.get('/getProduto', async (req, res) => {
    const { indiceProduto } = req.body;
    try {
        res.status(201).json({ produto: jogos[indiceProduto] });
    } catch(err) {
        console.log(err);
        res.status(400).json({err});
    }
});

app.get('/getUsuario', async (req, res) => {
    const { idUsuario } = req.body;
    try {
        const busca = await Usuario.find({ _id: idUsuario });
        res.status(201).json(busca);
    } catch(err) {
        console.log(err);
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