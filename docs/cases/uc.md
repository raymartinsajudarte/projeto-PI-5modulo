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

### Diagrama do Caso de Uso - 01
<img width="566" height="565" alt="image" src="https://github.com/user-attachments/assets/e388ef1a-c8e9-494d-8189-198978116ecd" />



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

### Diagrama do Caso de Uso - 02
<img width="578" height="521" alt="image" src="https://github.com/user-attachments/assets/2366b605-6b23-4edb-b3b5-a83ddd9d5b4e" />



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

### Diagrama do Caso de Uso - 03
<img width="441" height="610" alt="image" src="https://github.com/user-attachments/assets/0d107d23-b5dc-4e7a-a35d-3cb4fee36a8c" />



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

### Diagrama do Caso de Uso - 04
<img width="682" height="597" alt="image" src="https://github.com/user-attachments/assets/00d1c5fd-d2c5-4a1a-aaf0-bfd193e9453e" />



## UC05 — Interação com a IA

### Ator Principal:
Usuário

### Objetivo:
Permitir que o usuário interaja com um assistente virtual para obter ajuda.

### Pré-condições:
- O usuário deve estar autenticado no sistema.

### Pós-condições:
- O usuário recebe orientações ou realiza um agendamento através do chat.

### Fluxo Principal:
1) O usuário acessa a tela de chat.
2) O sistema exibe uma mensagem inicial de boas-vindas.
3) O usuário digita uma mensagem solicitando ajuda ou serviço.
4) O sistema processa a mensagem do usuário.
5) O sistema responde com informações ou opções de agendamento.
6) O usuário pode continuar a interação até concluir sua solicitação.

### Fluxos Alternativos:
- **A1 — Mensagem não compreendida:**
O sistema informa que não entendeu a solicitação e pede para o usuário reformular a mensagem.

- **A2 — Falha na comunicação:**
O sistema informa que ocorreu um erro e solicita que o usuário tente novamente.

### Regras de Negócio:
- RN08

### Requisitos Relacionados:
- RF08

### Diagrama do Caso de Uso - 05
<img width="516" height="582" alt="image" src="https://github.com/user-attachments/assets/c0f4c46f-171d-4887-8f58-7be08cb633fc" />



## UC06 — Cancelar Agendamento

### Ator Principal:
Usuário

### Objetivo:
Permitir que o usuário cancele um agendamento previamente realizado.

### Pré-condições:
- O usuário deve estar autenticado ao sistema e realizado um agendamento.

### Pós-condições:
- O agendamento é removido e marcado como cancelado no sistema.

### Fluxo Principal:
1) O usuário acessa a lista de agendamentos.
2) O sistema exibe os agendamentos ativos.
3) O usuário seleciona um agendamento.
4) O usuário solicita o cancelamento.
5) O sistema solicita confirmação.
6) O usuário confirma o cancelamento.
7) O sistema atualiza o status no banco de dados.

### Fluxos Alternativos:
- **A1 — Cancelamento Não Permitido:**
O sistema informa que o prazo do cancelamento expirou.

### Regras de Negócio:
- RN03, RN05

### Requisitos Relacionados:
- RF07

### Diagrama do Caso de Uso - 06
<img width="599" height="610" alt="image" src="https://github.com/user-attachments/assets/064026bb-199e-40d8-a5b3-36a746258d0b" />



## UC07 — Realizar Logout

### Ator Principal:
Usuário

### Objetivo:
Encerrar a sessão do usuário no sistema.

### Pré-condições:
- O usuário deve estar autenticado ao sistema.

### Pós-condições:
- Sessão encerrada com sucesso.

### Fluxo Principal:
1) O usuário seleciona a opção de logout.
2) O sistema invalida a sessão do usuário.
3) O sistema redireciona para a tela inicial/login.

### Fluxos Alternativos:
- N/A

### Regras de Negócio:
- N/A

### Requisitos Relacionados:
- RF06

### Diagrama do Caso de Uso - 07
<img width="400" height="319" alt="image" src="https://github.com/user-attachments/assets/7e0673d0-95a5-4086-a99f-d66288d494bf" />




## UC08 — Recuperar Senha

### Ator Principal:
Usuário

### Objetivo:
Permitir que o usuário recupere o acesso à sua conta.

### Pré-condições:
- Usuário possuir e-mail cadastrado.

### Pós-condições:
- Senha redefinida com sucesso.

### Fluxo Principal:
1) O usuário acessa a opção “esqueceu a senha?”.
2) O usuário informa o e-mail.
3) O sistema verifica se o e-mail existe.
4) O sistema envia um link/token de recuperação.
5) O usuário acessa o link.
6) O usuário define uma nova senha.
7) O sistema atualiza a senha no banco de dados.

### Fluxos Alternativos:
- A1 — E-mail não encontrado: O sistema informa que o e-mail não está cadastrado.
- A2 — Token inválido/expirado: O sistema solicita nova solicitação.

### Regras de Negócio:
- RN06

### Requisitos Relacionados:
- RF05

### Diagrama do Caso de Uso - 08
<img width="570" height="673" alt="image" src="https://github.com/user-attachments/assets/0414a24f-70ba-4c35-933f-864abc8d12dd" />
