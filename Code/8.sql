WITH CTE1 AS (
	SELECT
		(customers.first_name::text || ' ' || customers.last_name) AS customer,
		SUM(price) AS paid_per_month,
		DATE_TRUNC('month', tickets.purchased_at)::date AS purchase_time
	FROM tickets
	JOIN customers ON
		customers.id = tickets.customer_id
	WHERE tickets.status = 'paid'
	GROUP BY customer, purchase_time
	ORDER BY customer, purchase_time
),

CTE2 AS (
SELECT 
	customer,
	paid_per_month,
	purchase_time,
	LAG(paid_per_month, 1) OVER(PARTITION BY customer ORDER BY purchase_time) AS prev_paid_per_month
	FROM CTE1
),

CTE3 AS (
	SELECT
		customer,
		paid_per_month,
		(CASE 
			WHEN prev_paid_per_month IS NULL THEN 1
			WHEN paid_per_month > prev_paid_per_month THEN 1
			ELSE 0
		END)
		AS activity_indicator
	FROM CTE2
)

SELECT 
	customer, 
	month_count,
	min_monthly_spend,
	max_monthly_spend
FROM (
	SELECT 
		customer,
		MIN(paid_per_month) AS min_monthly_spend,
		MAX(paid_per_month) AS max_monthly_spend,
		(CASE 
			WHEN MIN(activity_indicator) = 0 THEN -1
			ELSE COUNT(*)
		 END) AS month_count
	
	FROM CTE3
	GROUP BY customer
)
WHERE month_count >= 3
ORDER BY month_count DESC, max_monthly_spend DESC, customer ASC