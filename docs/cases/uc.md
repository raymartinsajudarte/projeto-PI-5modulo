### Casos de Uso (UC)

##

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



## UC03 — Editar Perfil

### Ator Principal:
Usuário

### Objetivo: 
Permitir que o usuário altere informações do seu perfil dentro da plataforma.

### Pré-condições:
- O usuário deve estar autenticado no sistema.

### Pós-condições:
- As informações do perfil são atualizadas no banco de dados.

### Fluxo Principal:
1) O usuário acessa a área de perfil.
2) O sistema exibe as informações atuais do usuário.
3) O usuário seleciona a opção de editar perfil.
4) O usuário altera os dados desejados (nome, e-mail, senha, telefone ou foto).
5) O sistema valida os dados inseridos.
6) O sistema salva as alterações no banco de dados.

### Fluxos Alternativos:
- **A1 — Dados Invalidos:**
O sistema informa que os dados inseridos são inválidos e solicita correção.

### Regras de Negócio:
- RN02

### Requisitos Relacionados:
- RF03



## UC04 — Realizar Agendamento

### Ator Principal:
Usuário

### Objetivo:
Permitir que o usuário agende um horário para atendimento na barbearia.

### Pré-condições:
- O usuário deve estar autenticado no sistema.

### Pós-condições:
- O agendamento é registrado no sistema.

### Fluxo Principal:
1) O usuário acessa a tela de agendamento.
2) O sistema exibe um calendário contendo as datas.
3) O usuário seleciona a data desejada.
4) O usuário seleciona o horário disponível.
5) O usuário seleciona o tipo do serviço.
6) O usuário escolhe o método de pagamento.
7) O sistema confirma o agendamento.
8) O sistema registra o agendamento no banco de dados.

### Fluxos Alternativos:
- **A1 — Horário indisponível:**
O sistema informa que o horário já foi ocupado e solicita nova escolha.

### Regras de Negócio:
- RN03, RN04, RN07

### Requisitos Relacionados:
- RF04



