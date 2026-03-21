SELECT 
	MIN(vcm.total_revenue) AS min_clv,
	PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY vcm.total_revenue ASC) AS p25_clv,
	PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY vcm.total_revenue ASC) AS median_clv,
	AVG(vcm.total_revenue) AS avg_clv,
	PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY vcm.total_revenue ASC) AS p75_clv,
	MAX(vcm.total_revenue) AS max_clv
FROM
	analytics.vw_customer_metrics vcm