const mongoose = require('mongoose');
const { isEmail } = require('validator');
const bcrypt = require('bcryptjs');

const UsuarioSchema = new mongoose.Schema({
	email: {
		type: String,
		required: [true, 'por favor, informe um email'],
		unique: true,
		lowercase: true,
		validate: [isEmail, 'por favor, informe um email válido']
	},
	senha: {
		type: String,
		required: [true, 'por favor, informe uma senha'],
		minlength: [6, 'a senha deve conter no mínimo 6 caracteres']
	}
});

// dispara uma função antes do doc ser salvo no db
UsuarioSchema.pre('save', async function(next) {
	const salt = await bcrypt.genSalt();
	this.senha = await bcrypt.hash(this.senha, salt);
	next();
});

// método estático para logar usuário
UsuarioSchema.statics.login = async function(email, senha) {
	const Usuario = await this.findOne({email: email});
	if (Usuario) {
		const auth = await bcrypt.compare(senha, Usuario.senha);

		if (auth)
			return Usuario
		else
			throw Error('senha incorreta');
	}

	throw Error('email incorreto');
}

const Usuario = mongoose.model('Usuario', UsuarioSchema);

module.exports = Usuario;