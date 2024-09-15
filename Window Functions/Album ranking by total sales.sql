-- Write an SQL query to rank albums based on their total sales. 
-- Display the AlbumId, Title, and the rank of each album where the rank is based on the total sales amount in descending order.

WITH A AS
	(
SELECT
	a.AlbumId ,
	a.Title,
	SUM(il.UnitPrice * il.Quantity) AS total_sales
FROM
	Track t
JOIN Album a 
	ON
	t.AlbumId = a.AlbumId
JOIN InvoiceLine il 
	ON
	t.TrackId = il.TrackId
GROUP BY
	a.AlbumId) 
SELECT
	*,
	RANK() OVER(
	ORDER BY total_sales DESC) AS rank,
	DENSE_RANK() OVER(
	ORDER BY total_sales DESC) AS Dense_rank,
	ROW_NUMBER() OVER(
	ORDER BY total_sales DESC) AS row_number_rank
FROM
	A