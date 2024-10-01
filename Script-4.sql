with main as 
(
select
	cam.id as campaign_id ,
	c.id as main_id,
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
	cam.id = 60) ,
base as 
(
select
	t.* ,
	case
		when duration > '00:01:30' then 'GREEN'
		else 'RED'
	end as contact_duration_category,
	l.id
from
	main t
left join ecrm.locations l 
on
	t.location_id = l.id) ,
tbl as
(select l.id, l.name as outlet, l2.parent
from ecrm.locations l, ecrm.locations l2  
where l.parent = l2.id),
t2 as 
(SELECT tbl.id, tbl.outlet, l."name" as cluster, l.parent as next_id
FROM tbl, ecrm.locations l
where tbl.parent = l.id),
t3 as 
(SELECT t2.id, t2.outlet, t2.cluster, l."name" as point, l.parent as next_id
FROM t2, ecrm.locations l
where t2.next_id = l.id),
t4 as 
(SELECT t3.id, t3.outlet, t3.cluster, t3.point, l."name" as territory, l.parent as next_id
FROM t3, ecrm.locations l
where t3.next_id = l.id),
t5 as 
(SELECT t4.id, t4.outlet, t4.cluster, t4.point, t4.territory, l."name" as area, l.parent as next_id
FROM t4, ecrm.locations l
where t4.next_id = l.id),
t6 as 
(SELECT t5.id, t5.outlet, t5.cluster, t5.point, t5.territory, t5.area, l."name" as region
FROM t5, ecrm.locations l
where t5.next_id = l.id)
select b.*, t6.*
from t6
left join base b
on b.location_id = t6.id




