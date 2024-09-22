-- list other cabs we can suggests to our customer, 
-- based on their price range, seat, and state

with AvailableCabs as
(select c.*
from cab c
left join order_details od 
on c.id  = od.cab_id 
where c.id not in(select cab_id from order_details)
order by c.id)
select * from AvailableCabs

select *
from customers c 
left join AvailableCabs a
on c.from_state = a.state
where a.charge between c.min_rent and c.max_rent 
and c.min_seater >= a.seater


select * from cab c ;
select * from order_details od ;
select * from customers c ;