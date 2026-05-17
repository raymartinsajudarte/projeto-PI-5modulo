require('dotenv').config();
const { GoogleGenerativeAI } = require("@google/generative-ai");
const appointments = require('../controllers/appointmensts_controllers');
const services = require('../controllers/services_controllers');
const payments = require('../controllers/payments_controllers');

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const getControllerData = async (controllerFunction) => {
    let result = null;
    const mockRes = {
        status: function () { return this; },
        json: function (val) { result = val; return this; }
    };
    await controllerFunction({}, mockRes);
    return result;
};

/**
 * @param {string} userPrompt - Mensagem atual do usuário
 * @param {Array}  history    - Histórico [{role, parts:[{text}]}, ...]
 * @returns {{ responseText: string, updatedHistory: Array }}
 */

exports.generateResponse = async (userPrompt, history = []) => {
    try {
        const [dadosServicos, dadosHorarios, dadosPagamentos] = await Promise.all([
            getControllerData(services.list_light),
            getControllerData(appointments.list_shedule),
            getControllerData(payments.list),
        ]);

        const horariosOcupadosStr = JSON.stringify(dadosHorarios);
        const dataHoje = new Intl.DateTimeFormat('fr-CA', {
            timeZone: 'America/Sao_Paulo'
        }).format(new Date());

        const model = genAI.getGenerativeModel({
            model: "gemini-flash-latest",
            systemInstruction: `Você é o assistente de agendamento da "Barbearia Avenida".
            Hoje é dia ${dataHoje}. Sua missão é coletar: serviço, horário e pagamento.
            Horário de atendimento: segunda a sábado, 8h as 11h e 13h as 18h (horários inteiros).
            SERVIÇOS: ${dadosServicos}
            PAGAMENTOS: ${dadosPagamentos}
            HORÁRIOS OCUPADOS (nunca ofereça): ${horariosOcupadosStr}
            REGRAS:
            - Sugira apenas horários livres.
            - Horário ou serviço inválido → peça outro.
            - Serviços e pagamentos devem ser definidos apenas pelo ID ex: servico_escolhido: 1.
            - Finalize (atendimento_finalizado: true) só quando as 4 informações forem válidas.
            SAÍDA: responda APENAS em JSON válido, sem texto livre ou markdown:
            {
            "mensagem": "sua resposta ao cliente",
            "servico_escolhido": null,
            "dia_escolhido": null,
            "horario_escolhido": null,
            "pagamento_escolhido": null,
            "atendimento_finalizado": false
            }`,
            generationConfig: {
                responseMimeType: "application/json",
                maxOutputTokens: 2048,
                temperature: 0.2,
            },
        });

        // Inicia o chat com o histórico existente da sessão
        const chat = model.startChat({ history });

        const result = await chat.sendMessage(userPrompt);
        const responseText = result.response.text();

        // Monta o histórico atualizado para persistir na sessão
        const updatedHistory = [
            ...history,
            { role: "user",  parts: [{ text: userPrompt   }] },
            { role: "model", parts: [{ text: responseText }] },
        ];

        return { responseText, updatedHistory };

    } catch (error) {
        console.error("Erro no processamento da IA:", error);
        throw new Error("Falha ao gerar resposta da IA: " + error.message);
    }
};