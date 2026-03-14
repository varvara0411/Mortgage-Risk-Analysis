-- Анализ влияния переквалификации отклоненных заявок на процент одобрения в разрезе источников (source) получения заявок.

-- Результирующие столбцы:
-- - source: источник заявки
-- - total_cnt: общее количество полных заявок по источнику
-- - old_approve_cnt: количество одобренных сейчас
-- - new_approve_cnt: количество одобренных после переквалификации
-- - old_approval_rate_pct: текущий процент одобрения по источнику
-- - new_approval_rate_pct: потенциальный процент одобрения по источнику

-- Условие переквалификации: DECLINE → APPROVE, если initinal_payment >= 0.316.

select
    a.source,
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
left join spr_features f on r.spr_features_id = f.id
left join spr_application a on r.application_id = a.application_id
where r.request_type = 'FULL_APPLICATION'
group by a.source
order by a.source;

-- Для B2B approval_rate до внедрения правила равнялся 28.22%, а после внедрения правила - 48.56%.
-- Для SITE approval_rate до внедрения правила равнялся 32.92%, а после внедрения правила - 52.17%.