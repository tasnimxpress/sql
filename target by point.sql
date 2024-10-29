

-- target by point
with target_base as
(select 
	date,
	sum(target) over(partition by l3.id order by date) as target_by_date,
	l3.id as point_id,
	cmp_id
from ecrm.campaign_targets ct
left join ecrm.campaign_target_loc_maps ctlm on ct.id = ctlm.target_id
join ecrm.locations l1 on ctlm.loc_id = l1.id
left join ecrm.locations l2 on l2.id = l1.parent
left join ecrm.locations l3 on l3.id = l2.parent
left join ecrm.locations l4 on l4.id = l3.parent
left join ecrm.locations l5 on l5.id = l4.parent
left join ecrm.locations l6
on l6.id = l5.parent
where
	cmp_id = 60
	and ct.is_deleted = false
	and ct.is_current = true
	and l3.id = 2001
--	and date = '2024-07-08'
group by 
--	slab_name, 
	ct.name,
	cmp_id, 
	target,
	l3.id,
	l3.name,
	ct.date
order by l3.id),
-- final target update
target_final as (
select *
from target_base
group by cmp_id, date, point_id, target_by_date)
select * from target_final;
-- total br tbl
br_count_base as (
select c.user_id, c.contact_date, c.giveable
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
and contact_date = '2024-07-08'
and l4.id = 2001),
rank as (
select user_id, contact_date,
row_number () over(partition by user_id, contact_date) as total_by_date
from total_br),
user_count as (
select user_id, contact_date, count(total_by_date) over(partition by contact_date) as total_user
from rank
where total_by_date = 1
group by user_id, contact_date, total_by_date)
-- get target and total user
select u.*, t.*,
(total_user*cumulative_target_by_date) as target
from user_count u
left join target t
on u.contact_date = t.date;




--acheivement part
with achievement as 
(select 
	c.contact_date,
	l4.name as point,
	l4.id as point_id
from ecrm.contacts c 
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
	user_id,
	c.id,
	campaign_id, 
	contact_date,
	l4.id as point_id,
	l4.name as point
from ecrm.contacts c 
join ecrm.locations l1 
on c.location_id= l1.id
left join ecrm.locations l2 on l2.id = l1.parent
left join ecrm.locations l3 on l3.id = l2.parent
left join ecrm.locations l4 on l4.id = l3.parent
left join ecrm.locations l5 on l5.id = l4.parent 
left join ecrm.locations l6 on l6.id = l5.parent
left join ecrm.locations l7 on l7.id = l6.parent
where campaign_id = 60
and contact_date = '2024-07-08'
and l4.id = 2001
order by contact_date),
acv_base as (
select user_id,
	campaign_id, 
	contact_date,
	point_id,
	point, 
count(id) over(partition by user_id, contact_date, point_id order by contact_date) as achivement
from tbl)
select *
from acv_base
group by user_id, campaign_id, contact_date, point_id, point, achivement;