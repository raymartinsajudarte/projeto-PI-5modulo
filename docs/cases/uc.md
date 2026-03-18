## UC01 — Realizar Login

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
