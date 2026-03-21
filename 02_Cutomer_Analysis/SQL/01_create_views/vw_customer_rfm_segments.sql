CREATE VIEW vw_customer_rfm_segments AS
WITH rfm_base AS (
	SELECT 
		vcm.customerkey,
		vcm.full_name,
		vcm.recency_years,
		vcm.total_orders,
		vcm.total_revenue,
		vcm.total_profit,
		vcm.avg_order_value
	FROM
		analytics.vw_customer_metrics vcm
), 
rfm_score AS(
	SELECT 
		customerkey,
		CASE
			WHEN recency_years <= 1 THEN 5
			WHEN recency_years <= 3 THEN 4
			WHEN recency_years <= 5 THEN 3
			WHEN recency_years <= 7 THEN 2
			ELSE 1
		END AS r_score,
		NTILE(5) OVER(
			ORDER BY total_revenue 
		) AS m_score,
		CASE 
			WHEN total_orders = 1 THEN 1
			WHEN total_orders = 2 THEN 2
			WHEN total_orders BETWEEN 3 AND 4 THEN 3
			WHEN total_orders BETWEEN 5 AND 6 THEN 4
			WHEN total_orders >= 7 THEN 5
		END AS f_score	
	FROM
		rfm_base
),
rfm_segments AS(
	SELECT
		rfmb.customerkey,
		rfmb.full_name,
		rfmb.total_profit,
		rfmb.avg_order_value,
		rfmb.recency_years,
		rfms.r_score,
		rfmb.total_orders,
		rfms.f_score,
		rfmb.total_revenue,
		rfms.m_score,
		CASE 
			
			-- New Customers
			WHEN  rfmb.recency_years = 0
			THEN '8-New Customer'
			
			-- Champions
			WHEN r_score >= 4 AND f_score >= 3 AND m_score >= 4
			THEN '1-Champions'
			
			-- Potential Champions or Loyals
			WHEN r_score >= 4 AND f_score >= 2 AND m_score >= 4
			THEN '2-Potential Champions'
			
			-- Old High Value
			WHEN r_score = 1
			THEN '7-Lost Customers'
			
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
		rfm_score AS rfms
	LEFT JOIN
		rfm_base AS rfmb
		ON
		rfms.customerkey = rfmb.customerkey
)

SELECT 
	*
FROM
	rfm_segments