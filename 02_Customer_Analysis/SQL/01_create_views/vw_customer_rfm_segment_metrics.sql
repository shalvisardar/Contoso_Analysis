CREATE VIEW vw_customer_rfm_segment_metrics AS
WITH segment_base AS(
SELECT 
	vcrs.customer_segment,
	COUNT(*) AS num_customers,
	SUM(vcrs.total_revenue) AS revenue,
	SUM(vcrs.total_profit) AS profit,
	AVG(vcrs.avg_order_value) AS avg_order_value,
	(SUM(vcrs.total_profit) / SUM(vcrs.total_revenue))*100 AS profit_margin
FROM
	analytics.vw_customer_rfm_segments vcrs 
GROUP BY
	customer_segment
)

SELECT 
	customer_segment,
	num_customers,
	(num_customers / SUM(num_customers) OVER())*100 AS customers_share,
	revenue,
	(revenue / SUM(revenue) OVER())*100 AS revenue_share,
	profit,
	(profit / SUM(profit) OVER())*100 AS profit_share,
	avg_order_value,
	profit_margin
FROM
	segment_base 
ORDER BY
	customer_segment