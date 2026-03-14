-- Расчет процента заполненности полей pd и initinal_payment в таблице spr_features для каждого типа заявок с учетом как NULL-значений, так и пустых строк.

-- Результирующие столбцы:
-- - request_type: тип заявки (FULL_APPLICATION, SHORT_APPLICATION)
-- - cnt_rows: общее количество заявок данного типа
-- - cnt_with_pd: количество заявок с непустым pd (не NULL и не '')
-- - cnt_with_initinal_payment: количество заявок с непустым initinal_payment
-- - pd_fill_rate_pct: процент заполненности pd
-- - initinal_payment_fill_rate_pct: процент заполненности initinal_payment

select
    r.request_type,
    count(*) as cnt_rows,
    count(case when f.pd is not null and f.pd != '' then 1 end) as cnt_with_pd,
    count(case when f.initinal_payment is not null and f.initinal_payment != '' then 1 end) as cnt_with_initinal_payment,
    round(100.0 * 
          count(case when f.pd is not null and f.pd != '' then 1 end) / 
          count(*), 2) as pd_fill_rate_pct,
    round(100.0 * 
          count(case when f.initinal_payment is not null and f.initinal_payment != '' then 1 end) / 
          count(*), 2) as initinal_payment_fill_rate_pct
from spr_request r
left join spr_features f on r.spr_features_id = f.id
group by r.request_type
order by r.request_type;

-- После запуска видим, что ПВ и pd доступны только для FULL_APPLICATION, значит, эффект внедрения предложения корректно оценивать именно на FULL_APPLICATION (это видно и по csv файлу (если применить фильтр, например), но убедились в этом и через SQL-запрос).