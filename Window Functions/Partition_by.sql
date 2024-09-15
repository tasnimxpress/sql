-- calculate total sales for each album

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
SELECT * , SUM(Quantity*UnitPrice) OVER(PARTITION BY Title ORDER BY Title) AS total_sales
FROM A
