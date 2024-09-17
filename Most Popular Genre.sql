--Find the Most Popular Genre:
--Retrieve the GenreId and Name of the genre with the most tracks.

SELECT g.GenreId , g.Name , count(DISTINCT CustomerId) AS total_customer, COUNT(t.TrackId) AS total_track, SUM(Total) AS total_sales
FROM genre g
JOIN Track t 
ON g.GenreId = t.GenreId
JOIN InvoiceLine il 
ON t.TrackId = il.TrackId 
JOIN Invoice i 
ON il.InvoiceId = i.InvoiceId 
GROUP BY g.GenreId
ORDER BY total_customer DESC
LIMIT 5