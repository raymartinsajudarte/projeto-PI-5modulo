    const pool = require('../config/database');

exports.create = async (req, res) => {
    let connection;
    try {
        connection = await pool.getConnection();
        await connection.beginTransaction();

        //Desestruturar os dados (incluindo o array de serviços)
        const { id_usuario, id_pagamento, valor_total, dia, hora, servicos } = req.body;
        // Exemplo esperado de 'servicos': [{id_servico: 1, valor: 40.00}, {id_servico: 2, valor: 25.50}]

        // 2. Inserir na tabela principal (tb_agendamentos)
        const [resultAgendamento] = await connection.query(
            `INSERT INTO tb_agendamentos (id_usuario, id_pagamento, valor, dia, hora) VALUES (?, ?, ?, ?, ?)`,
            [id_usuario, id_pagamento, valor_total, dia, hora]
        );

        const newAgendamentoId = resultAgendamento.insertId;

        // 3. Inserir os serviços vinculados (tb_agendamento_servicos)
        // Criamos uma única query para múltiplos inserts (performance melhor)
        const valuesServicos = servicos.map(s => [
            newAgendamentoId, 
            s.id_servico, 
            s.valor_unitario
        ]);

        await connection.query(
            `INSERT INTO tb_agendamento_servicos (id_agendamento, id_servico, valor_unitario) VALUES ?`,
            [valuesServicos]
        );

        // 4. Se chegou aqui sem erros, confirma tudo no banco
        await connection.commit();
        
        res.status(201).json({ 
            message: 'Agendamento criado com sucesso!', 
            id: newAgendamentoId 
        });

    } catch (error) {
        // Se algo deu errado, desfaz as alterações
        if (connection) await connection.rollback();
        
        console.error(error);
        res.status(500).json({ error: 'Erro ao criar agendamento.' });

    } finally {
        if (connection) connection.release();
    }
};

exports.list_shedule = async (req, res) => {
    try {
        const [rows] = await pool.query(
            `select DATE_FORMAT(dia, '%Y-%m-%d') as dia, hora from tb_agendamentos where dia >= current_date() and status = 'confirmado' order by dia asc, hora asc;`
        );
        res.status(200).json(rows)
    } catch (error) {
        res.status(500).json({
            error: 'Erro ao buscar agendamentos'
        });
    };
};