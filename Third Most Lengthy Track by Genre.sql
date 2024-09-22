--Third most lengthy Track by Genre
--
--Use NTH_VALUE to find the third most lengthy track in each GenreId. 
--Display Gen566reId, TrackId, and the third highest UnitPrice.

SELECT GenreId , TrackId , t.Name , a.Title, Milliseconds ,
nth_value(t.Name, 7) 
OVER (PARTITION BY a.Title ORDER BY Milliseconds DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS third_most_lengthy_
FROM track t
JOIN Album a 
ON t.AlbumId = a.AlbumId 