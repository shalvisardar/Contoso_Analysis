CREATE VIEW vw_customer_metrics AS
SELECT
	vcob.customerkey,
	vcob.full_name,
	MIN(vcob.order_date) AS first_purchase_date,
	MAX(vcob.order_date) AS last_purchase_date,
	(MAX(vcob.order_date) - MIN(vcob.order_date)) AS lifespan_days,
	COUNT(DISTINCT vcob.orderkey) AS total_orders,
	SUM(vcob.revenue_usd) AS total_revenue,
	SUM(vcob.profit_usd) AS total_profit,
	SUM(vcob.quantity) AS total_units_purchased,
	(SUM(vcob.revenue_usd) / COUNT(DISTINCT vcob.orderkey)) AS avg_order_value,
	SUM(vcob.quantity) / COUNT(DISTINCT vcob.orderkey) AS avg_units_per_order,
	(SELECT EXTRACT(YEAR FROM (MAX(vcob.order_date))) AS max_date FROM vw_customer_order_base vcob) - EXTRACT(YEAR FROM(MAX(vcob.order_date))) AS recency_years
FROM
	analytics.vw_customer_order_base vcob
GROUP BY 
	vcob.customerkey,
	vcob.full_name