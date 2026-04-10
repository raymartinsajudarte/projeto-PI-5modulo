const bcrypt = require('bcrypt')
const pool = require('../config/database')
require('dotenv').config()

exports.login = async(req, res) => {
    try {
        const {nome_usuario, senha} = req.body

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

        if (rows.length === 0){
            return res.status(401).json({error: 'Credenciais inválidas'})
        }

        const usuario = rows[0]

        //comparar a senha digitada com a senha no banco de dados
        const senha_valida = await bcrypt.compare(senha, usuario.senha_hash)

        if (!senha_valida) {
            return res.status(401).json({error: 'Credenciais inválidas'})
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
        res.status(500).json({error: 'Erro interno'})
    }
}