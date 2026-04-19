select
    dia,
    hora
from
    tb_agendamentos
where
    dia >= current_date()
    and status = 'confirmado'
order by
    dia asc,
    hora asc;