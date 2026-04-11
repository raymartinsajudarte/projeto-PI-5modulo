const bcrypt = require('bcrypt')
const pool = require('../config/database')
require('dotenv').config()

exports.list = async (req, res) => {
    try {
        const [rows] =  await pool.query('select * from tb_usuarios')
        res.status(200).json(rows)
    } catch (error) {
        res.status(500).json({
            error: 'Erro ao buscar usuários'
        })
    }
}

exports.create = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        const { nome, nome_usuario, email, celular, senha} = req.body

        if (!nome || !nome_usuario || !email || !celular || !senha) {
            return res.status(400).json({
                error: 'Falta informações obrigatórias'
            })
        }

        await connection.beginTransaction();
    
        //gerar o token
        const salt_rounds = 10
        const senha_hash = await bcrypt.hash(senha, salt_rounds)

        //inserir no banco de dados
        const [result] = await pool.query(
            `INSERT INTO tb_usuarios (nome, nome_usuario, email, celular, senha_hash) VALUES (?,?,?,?,?)`,
            [nome, nome_usuario, email, celular, senha_hash]
        )

        const id_usuario = result.insertId

        // aqui vamos definir o perfil padrão para usuários sempre vai ser isso, qualquer um diferente de usuário precisará ser inserido na mão.
        const id_perfil = 3; // vai ficar fixo.

        await connection.query(
            `INSERT INTO tb_usuarios_perfis (id_usuario, id_perfil) VALUES (?,?)`, 
            [id_usuario, id_perfil]
        )

        await connection.commit()

        res.status(201).json({
            id_usuario: result.insertId,
            nome, 
            nome_usuario,
            email
        })

    }catch (error){
        res.status(500).json({
            error: 'Erro ao criar usuário!',
            details: error.message
        })
    }
}

exports.uploadFoto = async(req,res) => {
    try {
        const { id } = req.params

        if(!req.file) {
            return res.status(400).json({
                error: 'Arquivo não enviado!'
            })
        }

        const caminho = `/uploads/${req.file.filename}`

        await pool.query(
            `UPDATE tb_usuarios set foto = ? where id_usuario = ?`,
            [caminho, id]
        )

        res.json({
            message: "Arquivo enviado com sucesso",
            foto: caminho
        })
        
    } catch (error) {
        console.error(error)
        res.status(500).json({
            error: 'Erro ao enviar foto'
        })
    }
}


//Adicionado para buscar um usuario, para mostrar no perfil os dados.
exports.show = async (req, res) => {
    try {
        const { id } = req.params;

        const [rows] = await pool.query(
            `SELECT 
                id_usuario,
                nome,
                nome_usuario,
                email,
                celular,
                foto
            FROM tb_usuarios
            WHERE id_usuario = ?`,
            [id]
        );

        if (rows.length === 0) {
            return res.status(404).json({
                error: 'Usuário não encontrado'
            });
        }

        const usuario = rows[0];

        res.status(200).json({
            id: usuario.id_usuario,
            nome: usuario.nome,
            nome_usuario: usuario.nome_usuario,
            email: usuario.email,
            celular: usuario.celular,
            foto: usuario.foto
                ? `${process.env.BASE_URL}${usuario.foto}`
                : null
        });

    } catch (error) {
        res.status(500).json({
            error: 'Erro ao buscar usuário'
        });
    }
};