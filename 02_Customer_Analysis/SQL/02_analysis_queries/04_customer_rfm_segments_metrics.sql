-- CREATE VIEW vw_04_customer_rfm_segments_metrics AS
WITH segment_metrics_01 AS(
SELECT
	vcrs.customer_segment,
	ROUND((AVG(vcm.lifespan_days))::NUMERIC, 2) AS avg_lifetime,
	ROUND((AVG(vcm.total_orders))::NUMERIC, 2) AS avg_orders,
	ROUND((AVG(vcm.total_revenue))::NUMERIC, 2) AS avg_clv
FROM
	analytics.vw_customer_metrics vcm 
LEFT JOIN
	analytics.vw_customer_rfm_segments vcrs 
	ON
	vcm.customerkey = vcrs.customerkey 
GROUP BY
	customer_segment
ORDER BY
	customer_segment
),
segment_metrics_02 AS(
SELECT 
	vcrsm.customer_segment,
	ROUND((vcrsm.customers_share)::NUMERIC, 2) AS customer_share,
	ROUND((vcrsm.revenue_share)::NUMERIC, 2) AS revenue_share,
	ROUND((vcrsm.profit_share)::NUMERIC, 2) AS profit_share,
	ROUND((vcrsm.avg_order_value)::NUMERIC, 2) AS avg_order_value,
	sm.avg_lifetime,
	sm.avg_orders,
	sm.avg_clv 
FROM 
	analytics.vw_customer_rfm_segment_metrics vcrsm 
LEFT JOIN 
	segment_metrics_01 sm
	ON
	vcrsm.customer_segment = sm.customer_segment
)

SELECT 
	customer_segment,
	avg_clv,
	avg_order_value
FROM
	segment_metrics_02 
ORDER BY
	avg_clv DESC