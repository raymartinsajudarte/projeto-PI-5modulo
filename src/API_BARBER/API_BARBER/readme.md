# Documentação da API - Barbearia Avenida

# Informações Úteis para Execução da API

## Importação do Banco de Dados

Realizar o import do banco localizado no caminho:

```txt
projeto-PI-5modulo\src\DUMP_BANCO
```

Utilizar sempre o arquivo com a data mais recente.

---

# Configuração do Arquivo `.env`

Criar um arquivo `.env` na raiz do projeto seguindo o modelo abaixo:

```env
DB_HOST=localhost
DB_USER=usuario do banco
DB_PASSWORD=senha do banco
DB_NAME=db_barbearia_avenida

BASE_URL=http://ip da maquina:porta padrao
EX: BASE_URL=http://192.168.111.111:3000

PORT=porta pra subir a api

MAIL_USER='e-mail'
MAIL_PASS='senha gerada na config de app terceiro'

GEMINI_API_KEY='chave gerada no google I.A studio'
```

## Observações

### BASE_URL

A `BASE_URL` será necessária para o carregamento correto das imagens no sistema.

Exemplo:

```env
BASE_URL=http://192.168.111.111:3000
```

### Configuração de E-mail

As credenciais de e-mail serão enviadas separadamente para testes.

Requisitos:

* Utilizar uma conta Gmail.
* A conta deve possuir configuração de aplicativo de terceiros habilitada.

---

# Rotas da API

# Usuários

## Criação de Usuário

### Endpoint

```http
POST http://localhost:3000/users
```

### JSON de Envio

```json
{
 "nome":"João Victor Viana",
 "nome_usuario":"JoãoViana96",
 "email":"joao.teste@gmail.com",
 "celular":"19988880000",
 "senha":"123456"
}
```

### Retorno

```json
{
    "id_usuario": 1,
    "nome": "João Victor Viana",
    "nome_usuario": "JoãoViana96",
    "email": "joao.teste@gmail.com"
}
```

---

## Atualização de Informações do Usuário

### Endpoint

```http
PUT http://localhost:3000/users/id
```

### Observação

Todas as informações podem ser enviadas independentemente uma da outra.
Os campos não enviados manterão os valores atualmente salvos no banco de dados.

### JSON de Envio

```json
{
 "nome":"João Victor Viana",
 "nome_usuario":"JoãoViana96",
 "email":"joao.teste@gmail.com",
 "celular":"19988880000",
 "senha":"123456"
}
```

### Retorno

```json
{"message":"Usuário atualizado com sucesso"}
```

---

# Autenticação

## Login

### Endpoint

```http
POST http://localhost:3000/auth/login
```

### JSON de Envio

```json
{
 "nome_usuario":"JoãoViana96",
 "senha":"123456"
}
```

### Retorno

```json
{
"message":"Login efetuado com sucesso",
    "user":
    {
        "id":1,
        "nome":"joaovictor",
        "email":"joao.teste@gmail.com"
    }
}
```

---

## Esqueceu a Senha

### Endpoint

```http
POST http://localhost:3000/auth/forgot-password
```

### Observação

O token será enviado diretamente para o e-mail do usuário.

### JSON de Envio

```json
{
    "email": "seu-email-cadastrado@exemplo.com"
}
```

### Retorno

```json
{"message":"E-mail enviado com sucesso!","id":"id do envio do e-mail NÃO é o token"}
```

---

## Redefinição de Senha

### Endpoint

```http
POST http://localhost:3000/auth/reset-password
```

### JSON de Envio

```json
{
    "token": "cole_aqui_o_token_gerado_no_banco_ou_recebido_no_email",
    "nova_senha": "senhanovaaqui"
}
```

### Retorno

```json
{"message":"Senha redefinida com sucesso!"}
```

---

# Serviços

## Listagem de Serviços

### Endpoint

```http
GET http://localhost:3000/services
```

### Envio

Não é necessário enviar informações.

### Retorno

```json
[
    {
        "id_servico": 1,
        "nome": "corte cabelo",
        "valor": "40.00",
        "duracao_minutos": 40
    },
    {
        "id_servico": 2,
        "nome": "corte cabelo",
        "valor": "40.00",
        "duracao_minutos": 40
    },
    {
        "id_servico": 3,
        "nome": "barba",
        "valor": "25.00",
        "duracao_minutos": 30
    },
    {
        "id_servico": 4,
        "nome": "sobrancelha",
        "valor": "10.00",
        "duracao_minutos": 5
    },
    {
        "id_servico": 5,
        "nome": "descoloração",
        "valor": "80.00",
        "duracao_minutos": 90
    },
    {
        "id_servico": 6,
        "nome": "pigmentacao cabelo",
        "valor": "30.00",
        "duracao_minutos": 20
    },
    {
        "id_servico": 7,
        "nome": "pigmentacao barba",
        "valor": "20.00",
        "duracao_minutos": 15
    }
]
```

---

# Formas de Pagamento

## Listagem de Formas de Pagamento

### Endpoint

```http
GET http://localhost:3000/payments
```

### Envio

Não é necessário enviar informações.

### Retorno

```json
[
    {"id_forma_pagamento":1,"nome":"crédito"},
    {"id_forma_pagamento":2,"nome":"débito"},
    {"id_forma_pagamento":3,"nome":"dinheiro"},
    {"id_forma_pagamento":4,"nome":"pix"}
]
```

---

# Upload de Imagem

## Upload de Foto do Usuário

### Endpoint

```http
POST http://localhost:3000/users/'id do usuário'/foto
```

### Envio

A imagem deve ser enviada via `form-data` conforme o exemplo abaixo:

```txt
![alt text](image.png)
```

### Retorno

```json
{"message":"Arquivo enviado com sucesso","foto":"http://192.168.56.1:3000/uploads/user_2_1775604605028.png"}
```

---

# Agendamentos

## Criação de Agendamento

### Endpoint

```http
POST http://localhost:3000/appointments
```

### JSON de Envio

```json
{
  "id_usuario": 2,
  "id_pagamento": 3,
  "valor_total": 75.00,
  "dia": "2026-04-23",
  "hora": "10:00:00",
  "servicos": [
    {"id_servico": 1, "valor_unitario": 40.00},
    {"id_servico": 2, "valor_unitario": 25.00},
    {"id_servico": 3, "valor_unitario": 10.00}
  ]
}
```

### Retorno

```json
{"message":"Agendamento criado com sucesso!","id":4}
```

---

## Listagem de Agendamentos Registrados

### Objetivo

Utilizar esta rota para:

* Bloquear datas já ocupadas.
* Ocultar horários indisponíveis.

### Endpoint

```http
GET http://localhost:3000/appointments
```

### Envio

Não é necessário enviar informações.

### Retorno

```json
{
    "dia":"2026-04-20",
    "hora":"14:00:00"
},
{
    "dia":"2026-04-22",
    "hora":"16:00:00"
},
{
    "dia":"2026-04-23",
    "hora":"10:00:00"
}
```

---

# Histórico de Agendamentos

## Consulta de Todos os Agendamentos

### Endpoint

```http
GET http://localhost:3000/appointments/history
```

### Envio

Não é necessário enviar informações.

### Retorno

```json
[
    {"id_agendamento":1,"id_usuario":2,"nome":"Júlio Braido","foto":"/uploads/user_2_1775609023234.png","descricao servicos":"corte cabelo | barba","valor servicos":"R$ 40,00 | R$ 25,00","valor total":"65.00","dia":"2026-04-20","hora":"14:00","forma_pagamento":"crédito","status":"confirmado"},
    {"id_agendamento":2,"id_usuario":4,"nome":"João Victor Marcolino","foto":"/uploads/user_4_1775609345386.png","descricao servicos":"corte cabelo","valor servicos":"R$ 40,00","valor total":"40.00","dia":"2026-04-22","hora":"16:00","forma_pagamento":"débito","status":"confirmado"},
    {"id_agendamento":4,"id_usuario":2,"nome":"Júlio Braido","foto":"/uploads/user_2_1775609023234.png","descricao servicos":"corte cabelo | barba | sobrancelha","valor servicos":"R$ 40,00 | R$ 25,00 | R$ 10,00","valor total":"75.00","dia":"2026-04-23","hora":"10:00","forma_pagamento":"dinheiro","status":"confirmado"},
    {"id_agendamento":5,"id_usuario":5,"nome":"Agnaldo","foto":null,"descricao servicos":"corte cabelo | barba","valor servicos":"R$ 40,00 | R$ 25,00","valor total":"65.00","dia":"2026-05-21","hora":"10:00","forma_pagamento":"dinheiro","status":"confirmado"}
]
```

---

## Consulta de Agendamento Específico

### Endpoint

```http
GET http://localhost:3000/appointments/history/id
```

### Envio

Não é necessário enviar informações.

### Retorno

```json
[
    {"id_agendamento":5,"id_usuario":5,"nome":"Agnaldo","foto":null,"descricao servicos":"corte cabelo | barba","valor servicos":"R$ 40,00 | R$ 25,00","valor total":"65.00","dia":"2026-05-21","hora":"10:00","forma_pagamento":"dinheiro","status":"confirmado"}
]
```

---

# Chat com Inteligência Artificial

## Endpoint

```http
POST http://localhost:3000/ia/chat
```

## Objetivo

A ideia é permitir solicitações em linguagem natural, por exemplo:

```txt
"Quero cortar o cabelo semana que vem no período da manhã"
```

A partir disso, a I.A irá preencher automaticamente os parâmetros necessários para montagem do botão de resumo do agendamento.

### Parâmetros preenchidos pela I.A

```json
"servico_escolhido":"corte cabelo, luzes",
"dia_escolhido":"2026-05-09",
"horario_escolhido":"09:00",
"pagamento_escolhido":"crédito"
```

---

## Exemplos de Envio

### Exemplo 1

```json
{
    "sessionId":"1",
    "mensagem":"Olá gostaria de cortar o cabelo"
}
```

### Exemplo 2

```json
{
    "sessionId":"1",
    "mensagem":"sexta-feira que vem as 17:00"
}
```

### Exemplo 3

```json
{
    "sessionId":"1",
    "mensagem":"pagamento via pix"
}
```

---

## Resposta da I.A

```json
{
    "mensagem":"Agendamento confirmado! Corte de Cabelo no dia 22/05 às 17:00, com pagamento via Pix. A Barbearia Avenida agradece!",
    "servico_escolhido":1,
    "dia_escolhido":"2026-05-22",
    "horario_escolhido":"17:00:00",
    "pagamento_escolhido":4,
    "atendimento_finalizado":true
}
```