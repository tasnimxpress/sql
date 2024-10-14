--average call interval
--1st step: get end and next start time per contact
with main as
  (select id,
          user_id,
          "start"::time,
          "end"::time,
--          contact_date,
          lead("start"::time) over (partition by user_id order by "start") as next_start_time
   from ecrm.contacts c
   where campaign_id = 77
     and contact_date = '2024-10-08'),
--select * from main; 
--2nd step: get the interval per contact and average call interval per user
summary as
  (select *,
          (next_start_time - "end") as interval,
          avg(next_start_time - "end") over (partition by user_id) as avg_interval_per_user
   from main)
--   select * from summary;
   --final step: Get average call interval
select 
	avg(interval)::time  as avg_interval
from summary;




with main as 
(select
	id,
	user_id,
	"contact_date",
	"start"::time,
	"end"::time,
	lead("start"::time) over (partition by user_id, "start"::date order by contact_date, "start"::time) - "end"::time as interval
from ecrm.contacts c
where campaign_id = 77
and user_id = 18252)
select
avg(interval)::time as avg_interval
from main ;

extract EPOCH 
