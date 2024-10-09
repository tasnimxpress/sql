--average call interval
--1st step: get end and next start time per contact
with main as 
(select 
id,
user_id,
"start"::time,
"end"::time,
lead("start"::time) over (partition by user_id order by "start") as next_start_time
from ecrm.contacts c 
where campaign_id = 77
and contact_date = '2024-10-08'
),
--2nd step: get the interval per contact and average call interval per user
summary as 
(select *, 
(next_start_time - "end") as interval,
avg(next_start_time - "end") over (partition by user_id) as avg_interval_per_user
from main)
--final step: Get average call interval
--select * from summary;
select avg(avg_interval_per_user)::time as avg_interval
from summary;