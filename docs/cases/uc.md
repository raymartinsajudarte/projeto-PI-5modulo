## Casos de Uso (UC)

## UC01 — Cadastrar Novo Usuário

### Ator Principal:
Usuário

### Objetivo:
Registrar um novo usuário a base de dados do sistema da barbearia.

### Pré-condições:
- Usuário cadastra as informações necessárias.

### Pós-condições:
- Registro do usuário criado no banco de dados.

### Fluxo Principal:
1) O usuário acessa o menu de cadastro de usuário.
2) Preenche as informações requiridas pelo sistema como nome, email e senha.
3) O sistema valida as informações dos campos obrigatórios.
4) O sistema salva as informações no banco de dados e gera o método de login do usuário.

### Fluxos Alternativos:
- **A1 — Dados Incompletos:**
O sistema informa que os dados do email estão incompletos.

- **A2 — Dados Insuficientes:**
O sistema informa que há campos obrigatórios não preenchidos.

### Regras de Negócio:
- RN01, RN02

### Requisitos Relacionados:
- RF01



## UC02 — Realizar Login

### Ator Principal:
Usuário

### Objetivo: 
Autenticar o usuário para acesso às funcionalidades de login do sistema.

### Pré-condições:
- O usuário deve possuir um cadastro ativo no sistema.

### Pós-condições:
- O sistema permite a entrada do usuário com sucesso ao sistema.

### Fluxo Principal:
1) O usuário informa seu registro de login como nome e senha.
2) O sistema verifica se o usuário existe no banco de dados.
3) O sistema permite o acesso do usuário e o redireciona para a tela de agendamento de horários.

### Fluxos Alternativos:
- **A1 — Credenciais Incorretas:**
O sistema exibe uma mensagem de erro nos caracteres do login ao usuário.

- **A2 — Cadastro Inexistente:**
O sistema informa que não existe nenhum cadastro referente ao login utilizado.

### Regras de Negócio:
- RN01

### Requisitos Relacionados:
- RF02
