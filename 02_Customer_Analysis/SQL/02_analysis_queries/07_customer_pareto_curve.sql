CREATE VIEW vw_07_customer_pareto_curve AS
WITH pareto_base AS(
	SELECT 
		vcm.customerkey,
		NTILE(100) OVER(ORDER BY vcm.total_revenue DESC) AS percentile_buckets,
		vcm.total_revenue,
		SUM(vcm.total_revenue) OVER(ORDER BY vcm.total_revenue DESC) AS cumulative_revenue,
		SUM(vcm.total_revenue) OVER() AS total_db_revenue
	FROM 
		analytics.vw_customer_metrics vcm 
),
pareto_analysis AS(
	SELECT
		customerkey,
		total_revenue,
		percentile_buckets AS customer_percent,
		cumulative_revenue,
		(cumulative_revenue / total_db_revenue) AS revenue_percent
	FROM 
		pareto_base 
)

SELECT
	customer_percent,
	SUM(total_revenue) AS total_revenue, 
	MAX(cumulative_revenue) AS cumulative_revenue,
	MAX(revenue_percent) AS revenue_percent
FROM
	pareto_analysis
WHERE
	customer_percent % 10 = 0
GROUP BY
	customer_percent 
ORDER BY
	customer_percent 