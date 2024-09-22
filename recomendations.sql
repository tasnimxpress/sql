-- list other cabs we can suggests to our customer, based on their price range, seat, and state

select c.*
from cab c
left join order_details od 
on c.id  = od.cab_id 
where c.id not in(select cab_id from order_details)
order by c.id



select * from cab c ;
select * from order_details od ;