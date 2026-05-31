WITH daily_summary AS (
	SELECT 
		r.date as day, 
		SUM(t.price) AS daily_revenue
	FROM tickets t
	JOIN rides r 
		ON t.ride_id = r.id
	WHERE t.status = 'paid'
	GROUP BY r.date
)

SELECT 
	day, 
	daily_revenue, 
	SUM(daily_revenue) OVER(ORDER BY day ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM daily_summary
ORDER BY day ASC