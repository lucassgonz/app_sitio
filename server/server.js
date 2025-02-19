require('dotenv').config();
const express = require('express');
const bcrypt = require('bcryptjs');
const { MongoClient } = require('mongodb');
const jwt = require('jsonwebtoken');
const cors = require('cors')
const app = express();
app.use(cors())
app.use(express.json());
// Configurações do banco de dados
const uri = process.env.MONGO_URL;
const client = new MongoClient(uri);
const usersdb = client.db('proj_final').collection('users');

// Conexão com o MongoDB
client.connect()
  .then(() => console.log('✅ Conectado ao MongoDB'))
  .catch(err => console.log('❌ Erro na conexão:', err));

// Rota de login
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    // Verifica se o usuário existe
    const user = await usersdb.findOne({ email });
    console.log(JSON.stringify(user))
    if (!user) {
      return res.status(404).json({ message: 'Usuário não encontrado' });
    }

    // Verifica a senha
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Senha inválida' });
    }

    // Cria um token JWT
    const token = jwt.sign({ id: user._id, email: user.email }, process.env.JWT_SECRET, { expiresIn: '1h' });

    return res.json({ message: 'Login bem-sucedido', token });

  } catch (err) {
    console.error('Erro ao realizar o login:', err);
    return res.status(500).json({ message: 'Erro no servidor' });
  }
});

app.post('/api/register', async (req, res) => {
    const { nome, telefone, email, password, confirmPassword } = req.body;

    if (!nome || !telefone || !email || !password || !confirmPassword) {
        return res.status(400).json({ message: 'Todos os campos são obrigatórios.' });
    }

    if (password !== confirmPassword) {
        return res.status(400).json({ message: 'As senhas não coincidem.' });
    }

    try {
        const existingUser = await usersdb.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ message: 'E-mail já cadastrado.' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const result = await usersdb.insertOne({
            nome,
            telefone,
            email,
            password: hashedPassword,
        });

        return res.status(201).json({ message: 'Usuário cadastrado com sucesso!', userId: result.insertedId });
    } catch (error) {
        console.error('Erro ao cadastrar usuário:', error);
        return res.status(500).json({ message: 'Erro no servidor.' });
    }
});



// Inicia o servidor
app.listen(3000, () => console.log('🚀 Servidor rodando na porta 3000'));
