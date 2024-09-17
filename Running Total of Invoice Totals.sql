--Calculate the running total of Total for all invoices, 
--ordered by InvoiceDate. Display InvoiceId, InvoiceDate, and the running total.

SELECT i.InvoiceId , i.InvoiceDate , 
SUM(i.Total) OVER(ORDER BY i.InvoiceDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_sum
FROM Invoice i 