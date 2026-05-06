const gemini = require('../config/ia');

exports.chatAtendimento = async (req, res) => {
    try {
        const { mensagem } = req.body;

        if (!mensagem) {
            return res.status(400).json({ error: "Envie uma mensagem!" });
        }

        const respostaBrutaIA = await gemini.generateResponse(mensagem);

        // Remove markdown caso exista, e whitespace extra
        const jsonLimpo = respostaBrutaIA
            .replace(/```json\s*/gi, '')
            .replace(/```\s*/g, '')
            .trim();

        let objetoResposta;
        try {
            objetoResposta = JSON.parse(jsonLimpo);
        } catch (parseError) {
            // Loga o conteúdo bruto para facilitar debug
            console.error("Falha ao parsear JSON. Conteúdo recebido:", jsonLimpo);
            return res.status(500).json({
                error: "A IA retornou uma resposta inválida",
                details: parseError.message,
                rawResponse: jsonLimpo // visível no Postman para debug
            });
        }

        res.status(200).json(objetoResposta);

    } catch (error) {
        console.error("Erro ao processar:", error);
        res.status(500).json({
            error: "Erro ao processar sua pergunta",
            details: error.message,
        });
    }
};