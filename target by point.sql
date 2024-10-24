-- find campaign_target and achievements each day and each br cmp_id - 60(by point)
--find ptr target and achievment each day
--suppose campaign operation day = 90 days w/o weekend


-- target by point and date
with target as
(select 
	case 
		when ct.name like 'Slab 1%' then 'Slab 1'
		when ct.name like 'Slab 2%' then 'Slab 2'
		when ct.name like 'Slab 3%' then 'Slab 3'
		when ct.name like 'Slab 4%' then 'Slab 4'
	end as slab_category,
	ct.name as slab_name, 
	cmp_id, 
	date,
	max(target) as target,
	l3.id as point_id,
	l3.name as point,
	l4.name as territory,
	l5.name as area,
	l6.name as region,
	sum(target) over(partition by l3.name, l3.id) as total_target,
	sum(target) over(partition by l3.id order by date) as cumulative_target_by_date
from ecrm.campaign_targets ct
left join ecrm.campaign_target_loc_maps ctlm 
on ct.id = ctlm.target_id
join ecrm.locations l1
on ctlm.loc_id = l1.id
left join ecrm.locations l2 
on l2.id = l1.parent
left join ecrm.locations l3 
on l3.id = l2.parent
left join ecrm.locations l4 
on l4.id = l3.parent
left join ecrm.locations l5 
on l5.id = l4.parent
left join ecrm.locations l6
on l6.id = l5.parent
where
	cmp_id = 60
	and ct.is_deleted = false
	and ct.is_current = true
	and l3.id = 2001
group by 
	slab_name, 
	cmp_id, 
	target,
	l3.id,
	l3.name,
	ct.date,
	l4.name,
	l5.name,
	l6.name
order by l3.id)
select * from target;

select *
from ecrm.contacts c 
join ecrm.locations l1 
on c.location_id = l1.id 
left join ecrm.locations l2 on l1.parent = l2.id
left join ecrm.locations l3 on l2.parent = l3.id
left join ecrm.locations l4 on l3.parent = l4.id
left join ecrm.locations l5 on l4.parent = l5.id
left join ecrm.locations l6 on l5.parent = l6.id
left join ecrm.locations l7 on l6.parent = l7.id
where campaign_id = 60 
and contact_date = '2024-08-01'
and l4.id = 2001;
--order by user_id;
--count(distinct user_id) 



--acheivement part
with achievement as 
(select 
	c.contact_date,
--	c.giveable, 
--	m.name as ptr_name,
	l4.name as point,
	l4.id as point_id,
	count(l4.id) over(partition by l4.id, c.contact_date order by c.contact_date) as ptr_count
from ecrm.contacts c 
join ecrm.materials m 
on c.giveable = m.id 
join ecrm.locations l1
on c.location_id = l1.id
left join ecrm.locations l2 on l2.id = l1.parent
left join ecrm.locations l3 on l3.id = l2.parent
left join ecrm.locations l4 on l4.id = l3.parent
left join ecrm.locations l5 on l5.id = l4.parent
left join ecrm.locations l6 on l6.id = l5.parent
left join ecrm.locations l7 on l7.id = l6.parent
where campaign_id = 60
group by c.contact_date,
--	c.giveable, 
--	m.name,
	l4.name,
	l4.id 
order by c.contact_date, point_id)
select * from achievement;



with tbl as
(select 
	count(giveable) over(partition by contact_date, l4.id) as ptr_count,
	giveable,
	m.name,
	campaign_id, 
	contact_date,
	l4.id as point_id,
	l1.name as outlet,
	l2.name as dp,
	l3.name as route,
	l4.name as point,
	l5.name as territory,
	l6.name as area,
	l7.name as region
from ecrm.contacts c 
join ecrm.materials m 
on c.giveable = m.id
join ecrm.locations l1 
on c.location_id= l1.id
left join ecrm.locations l2 on l2.id = l1.parent
left join ecrm.locations l3 on l3.id = l2.parent
left join ecrm.locations l4 on l4.id = l3.parent
left join ecrm.locations l5 on l5.id = l4.parent 
left join ecrm.locations l6 on l6.id = l5.parent
left join ecrm.locations l7 on l7.id = l6.parent
where campaign_id = 60
and contact_date = '2024-07-16'
and l4.id = 2001
order by contact_date)
--select * from tbl;
select ptr_count, 
	campaign_id, 
	contact_date,
	point_id,
	point,
	territory,
	area,
	region
from tbl
group by ptr_count, 
	campaign_id, 
	contact_date,
	point_id ,
	point,
	territory,
	area,
	region

