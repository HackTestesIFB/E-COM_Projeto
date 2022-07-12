const mongoose = require('mongoose');

const CompraSchema = new mongoose.Schema({
	idUsuario: {type: String},
	data: {type: String},
	infoItens: {type: String}
});

const Compra = mongoose.model('Compra', CompraSchema);

module.exports = Compra;