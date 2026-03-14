
-- Распределение заявок по статусам в разрезе типов заявок.

-- Результирующие столбцы:
-- - request_type: тип заявки (FULL_APPLICATION, SHORT_APPLICATION)
-- - status: статус заявки (APPROVE, DECLINE, NEXT и т.д.)
-- - cnt: количество заявок данного типа с указанным статусом


select
    request_type,
    status,
    count(*) as cnt
from spr_request
group by request_type, status
order by request_type, status;