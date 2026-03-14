-- Расчет текущего и потенциального процента одобрения полных заявок после переквалификации отклоненных заявок с высоким первоначальным взносом.

-- Результирующие столбцы:
-- - total_cnt: общее количество полных заявок
-- - old_approve_cnt: количество одобренных сейчас
-- - new_approve_cnt: количество одобренных после переквалификации
-- - old_approval_rate_pct: текущий процент одобрения
-- - new_approval_rate_pct: потенциальный процент одобрения

-- Условие переквалификации: DECLINE → APPROVE, если initinal_payment >= 0.316


select
    count(*) as total_cnt,
    sum(case when r.status = 'APPROVE' then 1 else 0 end) as old_approve_cnt,
    sum(case 
            when r.status = 'DECLINE' and f.initinal_payment >= 0.316 then 1
            when r.status = 'APPROVE' then 1
            else 0 
        end) as new_approve_cnt,
    round(100.0 * sum(case when r.status = 'APPROVE' then 1 else 0 end) / count(*), 2) as old_approval_rate_pct,
    round(100.0 * sum(case 
            when r.status = 'DECLINE' and f.initinal_payment >= 0.316 then 1
            when r.status = 'APPROVE' then 1
            else 0 
        end) / count(*), 2) as new_approval_rate_pct
from spr_request r
left join spr_features f
    on r.spr_features_id = f.id
where r.request_type = 'FULL_APPLICATION';

-- Прирост одобрений: +165 заявок (с 239 до 404).