WITH pareto_base AS(
	SELECT 
		vcm.customerkey,
		ROW_NUMBER() OVER(ORDER BY vcm.total_revenue DESC) AS customer_rank,
		vcm.total_revenue,
		COUNT(vcm.customerkey) OVER() AS total_customers,
		SUM(vcm.total_revenue) OVER(ORDER BY vcm.total_revenue DESC) AS cumulative_revenue,
		SUM(vcm.total_revenue) OVER() AS total_db_revenue
	FROM 
		analytics.vw_customer_metrics vcm 
),
pareto_analysis AS(
SELECT 
	customer_rank,
	total_revenue,
	cumulative_revenue,
	ROUND((((customer_rank::NUMERIC) / total_customers) * 100)::NUMERIC, 2) AS customer_percent,
	ROUND(((cumulative_revenue / total_db_revenue) * 100)::NUMERIC, 2) AS revenue_percent
FROM 
	pareto_base 
)

SELECT
	customer_rank,
	customer_percent,
	revenue_percent
FROM
	pareto_analysis