-- Подсчет количества отклоненных полных заявок, которые могут быть переквалифицированы в одобренные на основе значения первоначального платежа.

-- Результирующие столбцы:
-- - cnt_reclassified: количество заявок, подлежащих переквалификации

-- Условия отбора:
-- - тип заявки: FULL_APPLICATION (полная заявка)
-- - текущий статус: DECLINE (отклонена)
-- - первоначальный платеж (initinal_payment) >= 0.316 (пороговое значение)

select
    count(*) as cnt_reclassified
from spr_request r
left join spr_features f
    on r.spr_features_id = f.id
where r.request_type = 'FULL_APPLICATION'
  and r.status = 'DECLINE'
  and f.initinal_payment >= 0.316;

-- Получаем количество заявок, которые перестанут автоматически отклоняться: 165 заявок.