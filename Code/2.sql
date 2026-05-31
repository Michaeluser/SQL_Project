WITH delay_data AS (
	SELECT rs.train_number, rds.date, ss.name, sps.departure_delay_min AS departure_delay, stop_order
	FROM ride_stops sps
	JOIN stations ss ON
		sps.station_id = ss.id
	JOIN rides rds ON
		sps.ride_id = rds.id
	JOIN routes rs ON
		rds.route_id = rs.id
	WHERE status IN ('completed', 'delayed') AND train_number = {{train_number}}
)

SELECT train_number, 
	date,
	name AS station,
	departure_delay,
	CASE 
		WHEN stop_order = 0 THEN Null
		ELSE 
			departure_delay - (LAG(departure_delay, 1) OVER (ORDER BY date, train_number, stop_order))
	END AS delay_change
	
FROM delay_data