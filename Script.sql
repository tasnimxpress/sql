-- locations 

select
l1.name as Region,
l2.name as Area,
l3.name as Territory,
l4.name as House, type = 4
l5.name as point, type = 5
l6.name as Route,
l7.name as cluster,
l8.name as outlet
from ecrm.locations l1
left join ecrm.locations l2
on l1.parent = l2.id
left join ecrm.locations l3
on l2.parent = l3.id
left join ecrm.locations l4
on l3.parent = l4.id
left join ecrm.locations l5
on l4.parent = l5.id
left join ecrm.locations l6
on l5.parent = l6.id
left join ecrm.locations l7
on l6.parent = l7.id
left join ecrm.locations l8
on l7.parent = l8.id




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
where l7.name like 'Rajshahi'
and l6.name like 'Bogura'
and l4.name like 'Pabna'
--and l3.name like 'Pabna'