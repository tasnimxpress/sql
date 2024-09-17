SELECT
	i.InvoiceDate, t.Name 
	total_sales,
	sum(total_sales)
over(
	partition by t.Name
order by
	InvoiceDate rows between unbounded preceding and current row) as total_sales_till_now
from
	(
	select
		InvoiceId,
		(UnitPrice * sum(Quantity)) as total_sales
	from
		InvoiceLine
	group by
		InvoiceId 
) as total
join Invoice i 
on
	i.InvoiceId = total.InvoiceId
join InvoiceLine il 
on
	i.InvoiceId = il.InvoiceId
join Track t 
on
	il.Trackid = t.Trackid
ORDER BY
	InvoiceDate;

select
		InvoiceId,
		(UnitPrice * sum(Quantity)) as total_sales
	from
		InvoiceLine
	group by
		InvoiceId 
