@startuml
left to right direction

actor Cliente
actor Cabeleireiro
actor Admin

rectangle Sistema {
  (Solicitar Agendamento)
  (Analisar Agenda)
  (Confirmar Agendamento)
  (Consultar Agenda)
  (Gerenciar Serviços)
  (Cadastro)
}

Cliente --> (Solicitar Agendamento)


(Solicitar Agendamento) --> (Analisar Agenda):<include>
(Analisar Agenda) --> (Confirmar Agendamento): <exchange>

Cabeleireiro --> (Consultar Agenda)

Admin --> (Cadastro)
Admin --> (Gerenciar Serviços)

@enduml

### Diagrama
![Diagrama](https://github.com/raymartinsajudarte/projeto-PI-5modulo/blob/main/docs/cases/diagrama/uc.png)
