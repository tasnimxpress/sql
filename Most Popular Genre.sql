--Find the Most Popular Genre:
--Retrieve the GenreId and Name of the genre with the most tracks.

SELECT *, count( DISTINCT CustomerId)
FROM genre g
JOIN Track t 
ON g.GenreId = t.GenreId
JOIN InvoiceLine il 
ON t.TrackId = il.TrackId 
JOIN Invoice i 
ON il.InvoiceId = i.InvoiceId 
GROUP BY g.GenreId