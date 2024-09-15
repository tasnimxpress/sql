-- Rank tracks based on their UnitPrice, displaying the TrackId, Name, and rank.


SELECT
	TrackId ,
	Name,
	RANK() OVER(
	ORDER BY UnitPrice desc) AS rank,
	DENSE_RANK() OVER(
	ORDER BY UnitPrice DESC) AS dense_rank,
	ROW_NUMBER() OVER(
	ORDER BY UnitPrice DESC) AS row_number
FROM
	Track t