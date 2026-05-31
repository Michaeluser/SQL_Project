WITH CTE1 AS (
	SELECT
		rides.id AS ride_id,
		routes.train_number AS r_train_number,
		rides.date AS ride_date,
		ride_wagons.position AS wagon_position,
		wagon_types.name AS railcar_type,
		ride_wagons.wagon_id,
		tickets.id AS ticket_id,
		wagon_types.seat_count AS capacity
	FROM routes
	
	RIGHT JOIN rides ON
		rides.route_id = routes.id
	LEFT JOIN ride_wagons ON
		rides.id = ride_wagons.ride_id
	
	JOIN tickets ON
		rides.id = tickets.ride_id AND ride_wagons.position = tickets.wagon_position
	
	JOIN wagons ON
		ride_wagons.wagon_id = wagons.id
	JOIN wagon_types ON
		wagons.wagon_type_id = wagon_types.id
	WHERE tickets.status IN ('paid', 'used') AND wagon_types.category = 'passenger'
)

SELECT 
	train_number, 
	date, 
	position,
	railcar_type,
	capacity,
	sold,
	ROUND(((sold::float / capacity) * 100)::numeric, 2) AS usage_percentage
FROM (
	SELECT 
		r_train_number AS train_number,
		ride_date AS date,
		wagon_position AS position,
		railcar_type,
		capacity,
		COUNT(ticket_id) AS sold
	FROM CTE1
	GROUP BY ride_id, wagon_id, train_number, ride_date, wagon_position, railcar_type, capacity
) SUBTABLE
ORDER BY usage_percentage DESC, train_number ASC, railcar_type ASC, date ASC, position ASC



