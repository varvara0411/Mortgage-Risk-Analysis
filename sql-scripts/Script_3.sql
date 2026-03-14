-- Расчет ключевых метрик для полных заявок (FULL_APPLICATION).

-- Результирующие столбцы:
-- - total_cnt: общее количество полных заявок
-- - approve_cnt: количество одобренных заявок (со статусом APPROVE)
-- - approval_rate_pct: процент одобрения (approve_cnt / total_cnt * 100)

select
    count(*) as total_cnt,
    sum(case when status = 'APPROVE' then 1 else 0 end) as approve_cnt,
    round(
        100.0 * sum(case when status = 'APPROVE' then 1 else 0 end) / count(*),
        2
    ) as approval_rate_pct
from spr_request
where request_type = 'FULL_APPLICATION';