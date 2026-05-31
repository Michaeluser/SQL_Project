WITH CTE1 AS (
	SELECT
		DATE_TRUNC('month', date)::date AS month,
		price
	FROM tickets ts
	JOIN rides rds ON
		ts.ride_id = rds.id
),

CTE2 AS (
	SELECT
		month,
		AVG(price) AS avg_price
	FROM CTE1
	GROUP BY month
),

CTE3 AS (
	SELECT
		month,
		avg_price,
		LAG(avg_price, 1) OVER (ORDER BY month) AS pmp
	FROM CTE2
)
SELECT
	month,
	ROUND(avg_price::numeric, 2) AS avg_price,
	ROUND(pmp::numeric, 2) as previous_month_avg,
	ROUND( ((avg_price - pmp) * 100 / pmp)::numeric, 2) AS change_percentage
FROM CTE3