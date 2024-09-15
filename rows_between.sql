-- n preceding m following

WITH A AS
	(SELECT a.Title , t.Name , InvoiceDate , il.UnitPrice , Quantity
	FROM Invoice i 
	JOIN InvoiceLine il 
	ON i.InvoiceId = il.InvoiceId 
	JOIN Track t 
	ON il.TrackId = t.TrackId 
	JOIN Album a 
	ON a.AlbumId = t.AlbumId 
	ORDER BY a.Title)
SELECT *, SUM(UnitPrice*Quantity) 
OVER(ORDER BY InvoiceDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS today_yesterday_nextday
FROM A