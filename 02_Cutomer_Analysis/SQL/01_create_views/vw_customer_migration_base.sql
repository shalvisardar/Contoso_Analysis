CREATE VIEW vw_customer_migration_base AS
WITH first_purchase AS(
	SELECT DISTINCT 
		vcob.customerkey,
		MIN(vcob.order_date) OVER(PARTITION BY vcob.customerkey) AS first_order_date
	FROM
		analytics.vw_customer_order_base vcob 
),
migration_base AS(
	SELECT 
		vcob.customerkey,
		EXTRACT(YEAR FROM fp.first_order_date) first_purchase_year,
		EXTRACT(YEAR FROM vcob.order_date) AS order_year,
		COUNT(DISTINCT vcob.orderkey) AS total_orders,
		SUM(vcob.revenue_usd) AS total_revenue
	FROM
		analytics.vw_customer_order_base vcob 
	LEFT JOIN
		first_purchase fp
		ON
		vcob.customerkey = fp.customerkey 
	GROUP BY
		vcob.customerkey,
		first_purchase_year,
		order_year
),
previous_order_year AS(
	SELECT 
		*,
		LAG(order_year) OVER(PARTITION BY customerkey ORDER BY order_year) AS prev_order_year
	FROM
		migration_base
),
migration_metrics AS(
	SELECT 
		customerkey,
		first_purchase_year,
		order_year,
		(order_year - prev_order_year) AS recency_years,
		total_orders,
		total_revenue
	FROM
		previous_order_year
),
migration_rfm_score AS(
SELECT
	customerkey,
	first_purchase_year,
	order_year,
	recency_years,
	total_orders,
	total_revenue,
	CASE
		WHEN recency_years <= 1 THEN 5
		WHEN recency_years <= 3 THEN 4
		WHEN recency_years <= 5 THEN 3
		WHEN recency_years <= 7 THEN 2
		ELSE 1
	END AS r_score,
	CASE
		WHEN total_orders = 1 THEN 1
		WHEN total_orders = 2 THEN 2
		WHEN total_orders = 3 THEN 3
		WHEN total_orders = 4 THEN 4
		ELSE 5
	END AS f_score,
	NTILE(5) OVER(
		PARTITION BY order_year 
		ORDER BY total_revenue
	) AS m_score
FROM
	migration_metrics
),
migration_rfm_segments AS(
	SELECT 
		customerkey,
		first_purchase_year,
		order_year,
		recency_years,
		total_orders,
		total_revenue,
		r_score,
		f_score,
		m_score,
		CASE 
			
			-- New Customers
			WHEN first_purchase_year = order_year 
			THEN '8-New Customer'
			
			-- Champions
			WHEN r_score >= 4 AND f_score >= 3 AND m_score >= 4
			THEN '1-Champions'
			
			-- Potential Champions or Loyals
			WHEN r_score >= 4 AND f_score >= 2 AND m_score >= 4
			THEN '2-Potential Champions'
			
			-- Old High Value
			WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3
			THEN '7-Lost Old Loyals'
			
			-- Single High Value Purchases
			WHEN r_score >= 3 AND f_score = 1 AND m_score >= 4
			THEN '3-Single High Value Purchases'
			
			-- New Low Value
			WHEN r_score >= 4 AND m_score <= 2
			THEN '4-Active Low Value'
			
			-- Old Low Value
			WHEN r_score <= 2 AND m_score <= 2 
			THEN '6-About to Sleep'
			
			ELSE '5-Mid-Value'
			
		END AS customer_segment
	FROM 
		migration_rfm_score
)

SELECT 
	*
FROM
	migration_rfm_segments