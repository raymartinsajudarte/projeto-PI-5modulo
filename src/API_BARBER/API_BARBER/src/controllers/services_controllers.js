const pool = require('../config/database');

exports.list = async (req, res) => {

    try {
        const [rows] = await pool.query('select id_servico, nome, valor, duracao_minutos from tb_servicos where ativo = 1;');
        res.status(200).json(rows)
    } catch (error) {
        res.status(500).json({
            error: 'Erro ao buscar serviços'
        })
    }
}

