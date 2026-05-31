WITH CTE AS(
	SELECT
		cs.first_name,
		cs.last_name,
		COUNT(class) FILTER(WHERE class = 1) AS count_1_class,
		COUNT(class) FILTER(WHERE class = 2) AS count_2_class
	FROM tickets ts
	JOIN customers cs ON
		ts.customer_id = cs.id
	WHERE status = 'paid' AND class IN (1, 2)
	GROUP BY cs.id, cs.first_name, cs.last_name
	ORDER BY cs.last_name ASC, cs.first_name ASC
)

SELECT 
	first_name,
	last_name,
	count_1_class,
	count_2_class
FROM CTE
WHERE count_1_class > 0 AND count_2_class > 0