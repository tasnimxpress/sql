with main as 
(
select
	cam.id as campaign_id ,
	c.id,
	c.contacted_br ,
	ui.full_name ,
	ui.official_contact ,
	c.location_id ,
	count(c.id) over(partition by c.id) as contact_count ,
	c."start" ,
	c."end" ,
	cast(c."end" as time) - cast(c."start" as time) as duration
from
	ecrm.contacts c
join ecrm.user_infos ui 
on
	c.user_id = ui.user_id
join ecrm.campaigns cam
on
	c.campaign_id = cam.id
where
	cam.id = 60)
select
	t.* ,
	case
		when duration > '00:01:30' then 'GREEN'
		else 'RED'
	end as contact_duration_category,
	l1.id, 
	l1.name as outlet,
	l2.name as cluster,
	l3.name as route,
	l4.name as point,
	l5.name as territory,
	l6.name as area,
	l7.name as region
from
	main t
join ecrm.locations l1 on
	t.location_id = l1.id
left join ecrm.locations l2 on
	l2.id = l1.parent
left join ecrm.locations l3 on
	l3.id = l2.parent
left join ecrm.locations l4 on
	l4.id = l3.parent
left join ecrm.locations l5 on
	l5.id = l4.parent
left join ecrm.locations l6 on
	l6.id = l5.parent
left join ecrm.locations l7 on
	l7.id = l6.parent
where
	t.id = 4713317 
	and l7.id is not null;



-- location table self join :outlet > cluster > route > point > territory > area > region
select 
	l1.id, 
	l1.name as outlet,
	l2.name as cluster,
	l3.name as route,
	l4.name as point,
	l5.name as territory,
	l6.name as area,
	l7.name as region
from ecrm.locations l1
left join ecrm.locations l2 on l2.id = l1.parent
left join ecrm.locations l3 on l3.id = l2.parent
left join ecrm.locations l4 on l4.id = l3.parent
left join ecrm.locations l5 on l5.id = l4.parent 
left join ecrm.locations l6 on l6.id = l5.parent
left join ecrm.locations l7 on l7.id = l6.parent
where l1.id = 252470 ;



SELECT 
    l1.id, 
    l1.name AS outlet, 
    l2.name AS cluster, 
    l3.name AS point, 
    l4.name AS territory, 
    l5.name AS area, 
    l6.name AS region
FROM 
    ecrm.locations l1
LEFT JOIN ecrm.locations l2 ON l1.parent = l2.id
LEFT JOIN ecrm.locations l3 ON l2.parent = l3.id
LEFT JOIN ecrm.locations l4 ON l3.parent = l4.id
LEFT JOIN ecrm.locations l5 ON l4.parent = l5.id
LEFT JOIN ecrm.locations l6 ON l5.parent = l6.id
WHERE l1.type = 8
and l1.id = 252470;
