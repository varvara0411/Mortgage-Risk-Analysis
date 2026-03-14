-- Расчет влияния переквалификации отклоненных заявок на процент одобрения (с фиксированным общим количеством заявок, равным 1000 - из csv файла).

-- Результирующие столбцы:
-- - total_apps: общее количество заявок (фиксированное значение 1000)
-- - old_approve_cnt: количество одобренных сейчас
-- - new_approve_cnt: количество одобренных после переквалификации
-- - old_approval_rate_total_pct: текущий процент одобрения (от 1000)
-- - new_approval_rate_total_pct: потенциальный процент одобрения (от 1000)

-- Условия переквалификации:
-- - Заявки со статусом DECLINE и первоначальным платежом >= 0.316 переходят в статус APPROVE

select
    1000 as total_apps,
    sum(case when r.status = 'APPROVE' then 1 else 0 end) as old_approve_cnt,
    sum(case 
            when r.status = 'DECLINE' and f.initinal_payment >= 0.316 then 1
            when r.status = 'APPROVE' then 1
            else 0 
        end) as new_approve_cnt,
    round(100.0 * sum(case when r.status = 'APPROVE' then 1 else 0 end) / 1000, 2) as old_approval_rate_total_pct,
    round(100.0 * sum(case 
            when r.status = 'DECLINE' and f.initinal_payment >= 0.316 then 1
            when r.status = 'APPROVE' then 1
            else 0 
        end) / 1000, 2) as new_approval_rate_total_pct
from spr_request r
left join spr_features f
    on r.spr_features_id = f.id
where r.request_type = 'FULL_APPLICATION';

-- Текущий approval_rate по 1000 заявкам = 23.9%, а после внедрения правила равен 40.4%.