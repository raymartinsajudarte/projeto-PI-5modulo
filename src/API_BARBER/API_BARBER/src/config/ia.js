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

const SERVICOS_AGENDAMENTO_IDS = [1, 2, 3, 4];

const formatarListaServicos = (lista) => {
    const filtrados = (lista || []).filter((s) =>
        SERVICOS_AGENDAMENTO_IDS.includes(s.id_servico)
    );
    if (filtrados.length === 0) {
        return '(nenhum serviço cadastrado)';
    }
    return filtrados
        .map((s) => `  - id_servico ${s.id_servico}: "${s.nome}"`)
        .join('\n');
};

const formatarListaPagamentos = (lista) => {
    if (!Array.isArray(lista) || lista.length === 0) {
        return '(nenhuma forma de pagamento cadastrada)';
    }
    return lista
        .map((p) => `  - id_forma_pagamento ${p.id_forma_pagamento}: "${p.nome}"`)
        .join('\n');
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

        const listaServicos = formatarListaServicos(dadosServicos);
        const listaPagamentos = formatarListaPagamentos(dadosPagamentos);
        const horariosOcupadosStr = JSON.stringify(dadosHorarios);
        const dataHoje = new Intl.DateTimeFormat('fr-CA', {
            timeZone: 'America/Sao_Paulo'
        }).format(new Date());

        const idsServicosValidos = (dadosServicos || [])
            .filter((s) => SERVICOS_AGENDAMENTO_IDS.includes(s.id_servico))
            .map((s) => s.id_servico)
            .join(', ');
        const idsPagamentosValidos = (dadosPagamentos || []).map((p) => p.id_forma_pagamento).join(', ');

        const model = genAI.getGenerativeModel({
            //model: process.env.GEMINI_MODEL || "gemini-flash-latest",
            //model: "gemini-flash-latest",
            model: "gemini-3.1-flash-lite",
            systemInstruction: `Você é o assistente de agendamento da "Barbearia Avenida".
            Hoje é dia ${dataHoje}. Colete: serviço (id), dia, horário e pagamento (id).
            Horário de atendimento: segunda a sábado, 8h às 11h e 13h às 18h (somente horários inteiros).

            === SERVIÇOS DISPONÍVEIS (ÚNICA FONTE DE VERDADE) ===
            ${listaServicos}
            IDs válidos para servico_escolhido: ${idsServicosValidos || 'nenhum'}

            === FORMAS DE PAGAMENTO (ÚNICA FONTE DE VERDADE) ===
            ${listaPagamentos}
            IDs válidos para pagamento_escolhido: ${idsPagamentosValidos || 'nenhum'}

            === HORÁRIOS JÁ OCUPADOS (nunca ofereça) ===
            ${horariosOcupadosStr}

            REGRAS OBRIGATÓRIAS:
            - Ao listar serviços ou pagamentos ao cliente, use SOMENTE os itens das listas acima.
            - Copie o nome EXATAMENTE como está entre aspas. Não traduza, não renomeie, não agrupe.
            - PROIBIDO inventar: combos, pacotes, "cabelo e barba", serviços ou pagamentos que não estejam nas listas.
            - servico_escolhido e pagamento_escolhido devem ser números (id) de itens que existem nas listas.
            - Sugira apenas horários livres dentro do expediente.
            - Se o cliente pedir algo fora da lista, explique o que está disponível e peça para escolher um id válido.
            - Finalize (atendimento_finalizado: true) só quando serviço, dia, horário e pagamento forem válidos.

            SAÍDA: responda APENAS em JSON válido, sem markdown:
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
                temperature: 0.1,
            },
        });

        const chat = model.startChat({ history });

        const result = await chat.sendMessage(userPrompt);
        const responseText = result.response.text();

        const updatedHistory = [
            ...history,
            { role: "user", parts: [{ text: userPrompt }] },
            { role: "model", parts: [{ text: responseText }] },
        ];

        return { responseText, updatedHistory };

    } catch (error) {
        console.error("Erro no processamento da IA:", error);
        throw new Error("Falha ao gerar resposta da IA: " + error.message);
    }
};
