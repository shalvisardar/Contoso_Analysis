SELECT 
	vccr.cohort_index,
	ROUND((AVG(vccr.customer_retention))::NUMERIC, 2) AS avg_retention
FROM 
	analytics.vw_customer_cohort_retention vccr 
GROUP BY
	cohort_index
ORDER BY
	cohort_index