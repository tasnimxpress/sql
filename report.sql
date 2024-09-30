	select count(c.id)
	from
		ecrm.contacts c
	join ecrm.contact_survey_data_maps csdm 
on 
		csdm.contact_id = c.id 
		and c.contact_date = '2024-09-05'
		and c.campaign_id = 60
	left join ecrm.user_infos ui 
on
		c.user_id = ui.user_id
	left join ecrm.outlets o
on
		c.location_id = o.location_id
	left join ecrm.consumers c2 
on
		c.consumer_id = c2.id
	left join ecrm.proximity_report pr 
on
		c.campaign_id = pr.campaign_id
	where
		
		
	group by
		c.campaign_id ,
		csdm.contact_id ,
		csdm.contact_date ,
		ui.full_name ,
		o.name ,
		c.contacted_br ,
		c2.name,
		pr.campaign_name ,
		c.contact_no ,
		c2."name" ,
		c2.fathers_name ,
		c2.address ,
		c.product ,
		c.giveable ,
		c."start" ,
		c."end" ,
		c2.dob) a ;



select
	c.campaign_id ,
	csdm.contact_id ,
	csdm.contact_date , 
	ui.full_name as user_full_name ,
	o.name as outlet_name ,
	c.contacted_br ,
	c2.name,
	pr.campaign_name ,
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
	csdm.contact_id = c.id
left join ecrm.user_infos ui 
on
	c.user_id = ui.user_id
left join ecrm.outlets o
on
	c.location_id = o.location_id
left join ecrm.consumers c2 
on
	c.consumer_id = c2.id
left join ecrm.proximity_report pr 
on
	c.campaign_id = pr.campaign_id
where
	c.campaign_id = 60
	and cast(c.contact_date as date) = cast('2024-09-05' as date)
group by
	c.campaign_id ,
	csdm.contact_id ,
	csdm.contact_date ,
	ui.full_name ,
	o.name ,
	c.contacted_br ,
	c2.name,
	pr.campaign_name ,
	c.contact_no ,
	c2."name" ,
	c2.fathers_name ,
	c2.address ,
	c.product ,
	c.giveable ,
	c."start" ,
	c."end" ,
	c2.dob
limit 10 ;




select
	count(*)
from
	ecrm.contacts
where
	campaign_id = 60
	and cast(contact_date as date) = cast('2024-09-05' as date)




select
	*
from
	ecrm.contacts
where
	campaign_id = 60
and 
	cast(contact_date as date) = cast('2024-09-05' as date)
	
	

select
	*
from
	ecrm.contact_survey_data_maps
where
	contact_id = 4620716
	
	


select
	*
from
	ecrm.outlets 
	
	
	

select
	*
from
	ecrm.users u 
	
	
	
	

select
	name,
	dob,
	current_date ,
	DATE_PART('year',
	current_date::date) - DATE_PART('year',
	dob::date) as age
from
	ecrm.consumers c