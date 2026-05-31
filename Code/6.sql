SELECT
	station_name AS destination,
	COUNT(station_name) AS routes_count
	
FROM(
	SELECT
		routes.id as route_id,
		FIRST_VALUE(stations.name) OVER(PARTITION BY routes.id ORDER BY stop_order) AS start_station,
		stations.name AS station_name,
		stop_order
	FROM routes
	JOIN route_stops ON
		routes.id = route_stops.route_id
	JOIN stations ON
		route_stops.station_id = stations.id
	ORDER BY routes.id, stop_order
) SUBTABLE
WHERE start_station LIKE 'Bratislava%' AND station_name NOT LIKE 'Bratislava%'
GROUP BY start_station, station_name
ORDER BY routes_count DESC, station_name ASC


