-- find the previous byte size, trailing track size, and difference with previous track size

WITH temp as
(
select
	TrackId ,
	Name,
	Bytes,
	lag(Bytes) over (
order by
	TrackId) as previous_track_size,
	lead(Bytes) over (
order by
	TrackId) as trailing_track_size
from
	Track t) 
SELECT
	*,
	CASE
		when (Bytes - trailing_track_size) < 0 then 0
		else Bytes - trailing_track_size
	END as diff
FROM
	temp