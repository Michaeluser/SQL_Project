WITH CTE1 AS (
	SELECT 
		train_number,
		scheduled_arrival_at AS start_date,
		scheduled_departure_at AS end_date,
		(LAG(scheduled_departure_at, 1) OVER(PARTITION BY train_number ORDER BY scheduled_arrival_at, scheduled_departure_at)) AS prev_end_date
	FROM ride_stops sps
	JOIN rides rds ON
		sps.ride_id = rds.id
	JOIN routes rs ON
		rds.route_id = rs.id
	WHERE status != 'cancelled'
),

CTE2 AS (
	SELECT
		train_number,
		start_date, 
		end_date,
		(CASE 
			WHEN prev_end_date >= start_date THEN 0
			WHEN end_date IS NULL THEN 0
			WHEN prev_end_date IS NULL THEN 1
			ELSE 1
		 END) AS interval_begin,
		(SUM(
			(CASE 
				WHEN prev_end_date >= start_date THEN 0
				WHEN end_date IS NULL THEN 0
				WHEN prev_end_date IS NULL THEN 1
				ELSE 1
			 END)) OVER(PARTITION BY train_number ORDER BY start_date)
		) AS interval_inx
	FROM CTE1
),
CTE3 AS (
	SELECT
		train_number,
		COUNT(interval_inx) AS series_length,
		(CASE WHEN MIN(start_date) IS NOT NULL THEN MIN(start_date)
			  ELSE MIN(end_date) END) AS from_date,
		(CASE WHEN MAX(end_date) IS NOT NULL THEN MAX(end_date)
			  ELSE MAX(start_date) END) AS to_date
	FROM CTE2
	GROUP BY interval_inx, train_number
	ORDER BY series_length DESC, train_number ASC
)

SELECT
	train_number,
	series_length,
	DATE_TRUNC('month', from_date)::date AS from_date,
	DATE_TRUNC('month', to_date)::date AS to_date
FROM CTE3
