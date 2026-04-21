const bcrypt = require('bcrypt')
const pool = require('../config/database')
//const resend = require('../config/mailer');
const transporter = require('../config/mailer')
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

exports.login = async (req, res) => {
    try {
        const { nome_usuario, senha } = req.body

        const [rows] = await pool.query(
            `SELECT 
                a.id_usuario, 
                a.nome, 
                a.nome_usuario,
                a.email, 
                a.foto,
                a.senha_hash,
                c.nome as nome_perfil 
            FROM tb_usuarios a 
                INNER JOIN tb_usuarios_perfis b ON a.id_usuario = b.id_usuario
                INNER JOIN tb_perfis c ON c.id_perfil = b.id_perfil
            WHERE
                a.nome_usuario = ? `,
            [nome_usuario]
        )

        if (rows.length === 0) {
            return res.status(401).json({ error: 'Credenciais inválidas' })
        }

        const usuario = rows[0]

        //comparar a senha digitada com a senha no banco de dados
        const senha_valida = await bcrypt.compare(senha, usuario.senha_hash)

        if (!senha_valida) {
            return res.status(401).json({ error: 'Credenciais inválidas' })
        }

        res.status(200).json({
            message: 'Login efetuado com sucesso',
            user: {
                id: usuario.id_usuario,
                nome: usuario.nome,
                nome_usuario: usuario.nome_usuario,
                email: usuario.email,
                foto: usuario.foto
                    ? `${process.env.BASE_URL}${usuario.foto}`
                    : null,
                perfil: usuario.nome_perfil
            }
        })

    } catch (error) {
        res.status(500).json({ error: 'Erro interno' })
    }
}

exports.forgotPassword = async (req, res) => {
    try {
        const { email } = req.body;

        const [users] = await pool.query('SELECT id_usuario, nome FROM tb_usuarios WHERE email = ?', [email]);
        if (users.length === 0) {
            return res.status(404).json({ error: 'E-mail não cadastrado' });
        }

        const token = crypto.randomBytes(20).toString('hex');
        const expires = new Date();
        expires.setHours(expires.getHours() + 1);

        await pool.query(
            'UPDATE tb_usuarios SET reset_token = ?, reset_token_expires_at = ? WHERE email = ?',
            [token, expires, email]
        );

        const nomeUsuario = users[0].nome;
        const resetLink = `${process.env.BASE_URL}/reset-password?token=${token}`;

        const templatePath = path.join(__dirname, '../templates/recovery_email.html');
        let htmlContent = fs.readFileSync(templatePath, 'utf8');

        htmlContent = htmlContent
            .replace('{{nome}}', nomeUsuario)
            .replace('{{link}}', resetLink);

        // Envio usando o Resend
        await transporter.sendMail({
            from: `"App Barbearia Avenida" <${process.env.MAIL_USER}>`,
            to: email,
            subject: 'Recuperação de Senha',
            html: htmlContent // Aqui vai o HTML processado
        });

        res.json({ message: 'E-mail enviado com sucesso!'});

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao processar solicitação' });
    }
};

exports.resetPassword = async (req, res) => {
    try {
        const { token, nova_senha } = req.body;

        if (!token || !nova_senha) {
            return res.status(400).json({ error: 'Token e nova senha são obrigatórios' });
        }

        // 1. Busca o usuário onde o token coincide E ainda não expirou
        // Usamos CURRENT_TIMESTAMP para comparar com o reset_token_expires_at
        const [users] = await pool.query(
            `SELECT id_usuario FROM tb_usuarios 
             WHERE reset_token = ? 
             AND reset_token_expires_at > CURRENT_TIMESTAMP`,
            [token]
        );

        if (users.length === 0) {
            return res.status(400).json({ error: 'Token inválido ou expirado' });
        }

        const id_usuario = users[0].id_usuario;

        // 2. Gera o hash da nova senha
        const salt_rounds = 10;
        const senha_hash = await bcrypt.hash(nova_senha, salt_rounds);

        // 3. Atualiza a senha e LIMPA os campos de reset
        // É vital setar como NULL para que o mesmo token não seja usado duas vezes
        await pool.query(
            `UPDATE tb_usuarios 
             SET senha_hash = ?, 
                 reset_token = NULL, 
                 reset_token_expires_at = NULL 
             WHERE id_usuario = ?`,
            [senha_hash, id_usuario]
        );

        res.status(200).json({ message: 'Senha redefinida com sucesso!' });

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao redefinir senha' });
    }
};