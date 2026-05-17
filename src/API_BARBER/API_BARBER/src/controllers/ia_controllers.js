const gemini = require('../config/ia');

/**
 * Sessões em memória: sessionId → { history, expiresAt }
 * Para produção, substitua por Redis ou outro store externo.
 */
const sessions = new Map();
const SESSION_TTL_MS = 30 * 60 * 1000; // 30 minutos

/** Retorna a sessão existente ou cria uma nova. */
function getOrCreateSession(sessionId) {
    const now = Date.now();

    if (sessions.has(sessionId)) {
        const session = sessions.get(sessionId);

        // Sessão expirada → recria
        if (now > session.expiresAt) {
            sessions.delete(sessionId);
        } else {
            // Renova o TTL a cada mensagem
            session.expiresAt = now + SESSION_TTL_MS;
            return session;
        }
    }

    const newSession = { history: [], expiresAt: now + SESSION_TTL_MS };
    sessions.set(sessionId, newSession);
    return newSession;
}

/** Limpeza periódica de sessões expiradas (roda a cada 15 min). */
setInterval(() => {
    const now = Date.now();
    for (const [id, session] of sessions.entries()) {
        if (now > session.expiresAt) sessions.delete(id);
    }
}, 15 * 60 * 1000);

exports.chatAtendimento = async (req, res) => {
    try {
        const { mensagem, sessionId } = req.body;

        if (!mensagem) {
            return res.status(400).json({ error: "Envie uma mensagem!" });
        }
        if (!sessionId) {
            return res.status(400).json({ error: "Envie um sessionId para identificar a conversa!" });
        }

        const session = getOrCreateSession(sessionId);

        const { responseText, updatedHistory } =
            await gemini.generateResponse(mensagem, session.history);

        // Persiste histórico atualizado na sessão
        session.history = updatedHistory;

        // Parse do JSON retornado pela IA
        const jsonLimpo = responseText
            .replace(/```json\s*/gi, '')
            .replace(/```\s*/g, '')
            .trim();

        let objetoResposta;
        try {
            objetoResposta = JSON.parse(jsonLimpo);
        } catch (parseError) {
            console.error("Falha ao parsear JSON. Conteúdo recebido:", jsonLimpo);
            return res.status(500).json({
                error: "A IA retornou uma resposta inválida",
                details: parseError.message,
                rawResponse: jsonLimpo,
            });
        }

        // Encerra a sessão se o agendamento foi concluído
        if (objetoResposta.atendimento_finalizado === true) {
            sessions.delete(sessionId);
        }

        return res.status(200).json(objetoResposta);

    } catch (error) {
        console.error("Erro ao processar:", error);
        return res.status(500).json({
            error: "Erro ao processar sua pergunta",
            details: error.message,
        });
    }
};