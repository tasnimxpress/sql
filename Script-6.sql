select c.id, ta.contact_id , ta.survey_start_time , c."start" , c."end", c.user_id ,
cast("end" as time) - cast("start" as time) as duration, max(ta.duration_from_start_survey)
from ecrm.contacts c 
join ecrm.tap_analyses ta 
on c.id = ta.contact_id
where c.campaign_id = 60
and ta.block_id = 'submit_Btn'
and cast("start" as time) > cast("end" as time)
and c.id in 
(4842194,
4725062,
4999282,
4999707,
4724767,
4911377,
5018932,
4722103,
4723659,
4970501,
4719613,
5018999,
5019424,
4722176,
4725748,
4829834,
4722299)
and c.user_id in 
(21847,
27224,
18218,
19520,
27224,
26979,
18218,
19323,
27224,
19520,
27224,
19520,
18218,
19323,
21847,
21847,
19323
)
group by c.id, ta.contact_id , ta.survey_start_time , c."start" , c."end", c.user_id
order by c.user_id ;









select
	c.id,
	c."start" ,
	c."end",
	c.user_id ,
	cast("end" as time) - cast("start" as time) as duration,
	max(ta.duration_from_start_survey),
	ta.survey_start_time
from ecrm.contacts c
left join ecrm.tap_analyses ta 
on c.id = ta.contact_id
where
	c.campaign_id = 60
	--and cast("start" as time) > cast("end" as time)
	and c.id = 4719613
	and c.user_id = 27224
	and ta.block_id = 'submit_Btn'
group by
	c.id,
	c."start" ,
	c."end",
	c.user_id ,
	ta.survey_start_time
order by
	c.user_id ;








select *
from ecrm.tap_analyses ta
where contact_id = 4719613
limit 5


