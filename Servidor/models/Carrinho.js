const mongoose = require('mongoose');

const CarrinhoSchema = new mongoose.Schema({
	idUsuario: {type: String},
	idProduto: {type: String},
	quantidade: {type: Number}
});

const Carrinho = mongoose.model('Carrinho', CarrinhoSchema);

module.exports = Carrinho;