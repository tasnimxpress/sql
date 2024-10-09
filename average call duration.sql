--- average call duration
--normal approach; without any other column
select 
avg("end" - "start")::time as Duration
from ecrm.contacts
where campaign_id = 77
and contact_date = '2024-10-08';


------- cte approach; possible to get other column like id, user_id
with main as
(select id, user_id,
("end"::time - "start"::time) as Duration --per contact
from ecrm.contacts
where campaign_id = 77
and contact_date = '2024-10-08')
--get overall duration average 
select
avg(duration)::time
from main ;