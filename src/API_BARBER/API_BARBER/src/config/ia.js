require('dotenv').config();
const { GoogleGenerativeAI } = require("@google/generative-ai");
const appointments = require('../controllers/appointmensts_controllers');
const services = require('../controllers/services_controllers');
const payments = require('../controllers/payments_controllers');

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

exports.generateResponse = async (userPrompt) => {
    try {
        // Função auxiliar para capturar o JSON dos controllers
        const getControllerData = async (controllerFunction) => {
            let result = null;
            const mockRes = {
                status: function () { return this; },
                json: function (val) { result = val; return this; }
            };
            // Passamos um objeto vazio como req para evitar erros de undefined
            await controllerFunction({}, mockRes);
            return result;
        };

        // 1. Consome os 3 controllers de forma assíncrona para pegar dados atuais
        const dadosServicos = await getControllerData(services.list);
        const dadosHorarios = await getControllerData(appointments.list_shedule);
        const dadosPagamentos = await getControllerData(payments.list);

        // 2. Transforma em String para injetar no prompt
        const servicosStr = JSON.stringify(dadosServicos);
        const horariosOcupadosStr = JSON.stringify(dadosHorarios);
        const pagamentosStr = JSON.stringify(dadosPagamentos);
        const dataHoje = new Intl.DateTimeFormat('fr-CA', {timeZone: 'America/Sao_Paulo'}).format(new Date());

        // 3. Configura o modelo DENTRO da função para usar os dados atualizados
        const model = genAI.getGenerativeModel({
            model: "gemini-flash-latest",
            systemInstruction: `Você é o assistente de agendamento da "Barbearua Avenida". 
            Hoje é dia ${dataHoje}. Sua missão é coletar: serviço, horário e pagamento.
            Horário de atendimento é de segunda a sabado das 8:00 da manhã as 11:00 e das 13:00 as 18:00
            OPÇÕES DISPONÍVEIS (Use os nomes para falar com o usuário, mas valide com os dados abaixo):
            - Serviços: ${servicosStr}
            - Formas de Pagamento: ${pagamentosStr}
            HORÁRIOS JÁ OCUPADOS (NÃO ofereça estes horários):
            - Ocupados: ${horariosOcupadosStr}
            REGRAS:
            - Você deve com base nas informações que o usuário enviar horarios disponíveis para o agendamento
            - Se o usuário escolher um horário que está na lista de "Ocupados", informe que não está disponível e peça outro.
            - Se o usuário escolher um serviço ou pagamento fora da lista, peça para escolher um válido.
            - Finalize (atendimento_finalizado: true) apenas quando as 4 informações forem válidas.
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
                temperature: 0.2, // Baixei para 0.2 para a IA ser mais precisa com o JSON
            },
        });

        // 4. Gera o conteúdo
        const result = await model.generateContent(userPrompt);
        const response = await result.response;

        // Retorna o texto (que deve ser um JSON puro)
        return response.text();

    } catch (error) {
        console.error("Erro no processamento da IA:", error);
        throw new Error("Falha ao gerar resposta da IA: " + error.message);
    };
};
