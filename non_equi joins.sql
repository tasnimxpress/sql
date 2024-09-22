-- possible customer pairs who can travel together irrespective to rent

select c.id, c.namee, c2.id, c2.namee, c.from_state 
from customers c , customers c2 
where c.id < c2.id
and c.from_state = c2.from_state


select c.id, c2.id,  c.namee, c2.namee, c.from_state 
from customers c 
join customers c2 
on c.from_state = c2.from_state 
where c.id < c2.id