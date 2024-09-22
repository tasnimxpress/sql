-- remove duplicate(different id same address and charge)

-- identify duplicates
select * 
from cab c 
join cab c2 
on c.id != c2.id
and c.state = c2.state 
and c.city = c2.city 
and c.charge = c2.charge


-- identify duplicates
SELECT MIN(c.id) AS id, c.state, c.city, c.charge
FROM cab c
GROUP BY c.state, c.city, c.charge


-- identify duplicates
WITH UniqueCabs AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY state, city, charge ORDER BY id) AS rn
    FROM cab
)
-- select * from UniqueCabs
-- remove duplicates
SELECT id, state, city, charge
FROM UniqueCabs
WHERE rn = 1
order by id;


select * from cab


