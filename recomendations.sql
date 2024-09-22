-- list other cabs we can suggests to our customer, 
-- based on their price range, seat, and state

with cabs as
(with AvailableCabs as
	(
	with AllCabs as
	(
select
	c.*,
		row_number() over (partition by c.state,
	c.city,
	c.charge
order by
	c.id) as rnk
from
	cab c
	)
select
	*
from
	allCabs
where
	rnk = 1)
select
	a.*
from
	AvailableCabs a
left join order_details od 
	on
	a.id = od.cab_id
where
	a.id not in (
	select
		cab_id
	from
		order_details od))
select
	c.*,
	cabs.id as cab_id,
	cabs.seater,
	cabs.charge,
	cabs.city
from
	customers c
join cabs 
on
	c.from_state = cabs.state
	and cabs.charge between c.min_rent and c.max_rent
	and c.min_seater <= cabs.seater