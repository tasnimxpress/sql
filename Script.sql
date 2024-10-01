select
	c.campaign_id ,
	c3.name as campaign_name,
	c.contact_date ,
	o.name as outlet_name , 
	ui.full_name as br_full_name ,
	c.contacted_br ,
	csdm.contact_id ,
	c2.name as consumer_name,
	c.contact_no ,
	c2."name" as consumer_name ,
	c2.fathers_name ,
	c2.address ,
	c.product ,
	c.giveable ,
	c."start" ,
	c."end" ,
	c2.dob as date_of_birth ,
	date_part('year',
	current_date::date) - date_part('year',
	c2.dob::date) as consumers_age ,
	cast(c."end" as time) - cast(c."start" as time) as duration
from
	ecrm.contacts c
join ecrm.contact_survey_data_maps csdm 
	on 
		c.id = csdm.contact_id 
join ecrm.user_infos ui 
on
	c.user_id = ui.user_id
left join ecrm.outlets o
on
	c.location_id = o.location_id
left join ecrm.consumers c2 
on
	c.consumer_id = c2.id
join ecrm.campaigns c3
on
	c.campaign_id = c3.id
where
	c.campaign_id = 60
	and cast(c.contact_date as date) = cast('2024-09-05' as date)
group by
	c.campaign_id ,
	c3.name ,
	c.contact_date ,
	o.name , 
	ui.full_name ,
	c.contacted_br ,
	csdm.contact_id ,
	c2.name,
	c.contact_no ,
	c2."name" ,
	c2.fathers_name ,
	c2.address ,
	c.product ,
	c.giveable ,
	c."start" ,
	c."end" ,
	c2.dob
order by ui.full_name
limit 10 ;

select *
from ecrm.contacts
limit 10

--select * 
--from ecrm.user_infos ui 
--order by id
--limit 10