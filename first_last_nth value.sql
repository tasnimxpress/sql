--Find the Name of track with Highest second highest and lowest bytes per Album
--
--Write a query to retrieve the name of the track name that has Highest, second highest and lowest bytes for each Album. 
--Display AlbumId, album name,  bytes and track name


SELECT a.AlbumId , a.Title , t.Name, t.Bytes , 
first_value(t.Name) 
OVER(PARTITION BY Title ORDER BY Bytes DESC) AS Highest_byte,
last_value(t.Name) 
OVER(PARTITION BY a.Title ORDER BY t.Bytes DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_byte,
nth_value(t.Name, 2) OVER(PARTITION BY a.Title ORDER BY t.Bytes DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS second_highest
FROM Track t 
JOIN Album a 
ON t.AlbumId = a.AlbumId 
ORDER BY a.Title 


