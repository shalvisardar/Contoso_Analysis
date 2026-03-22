CREATE VIEW vw_customer_cohort_retention AS
WITH cohort_year AS(
SELECT 
	vcob.customerkey,
	MIN(vcob.order_date) AS first_purchase
FROM 
	analytics.vw_customer_order_base vcob 
GROUP BY
	customerkey
),
cohort_base AS(
	SELECT DISTINCT
		EXTRACT (YEAR FROM (cy.first_purchase)) AS cohort_year,
		EXTRACT(YEAR FROM order_date) AS order_year,
		EXTRACT(YEAR FROM order_date) - EXTRACT (YEAR FROM (cy.first_purchase)) AS cohort_index,
		vcob.customerkey,
		vcob.full_name,
		SUM(vcob.revenue_usd) OVER(PARTITION BY vcob.customerkey, EXTRACT(YEAR FROM order_date)) AS revenue_usd,
		SUM(vcob.profit_usd) OVER(PARTITION BY vcob.customerkey, EXTRACT(YEAR FROM order_date)) AS profit_usd
	FROM
		vw_customer_order_base vcob 
	LEFT JOIN
		cohort_year cy
		ON
		vcob.customerkey = cy.customerkey 
),
cohort_index_metrics AS(
SELECT
	cohort_year,
	order_year,
	cohort_index,
	COUNT(DISTINCT customerkey) AS active_customers,
	SUM(revenue_usd) AS revenue,
	SUM(profit_usd) AS profit
FROM
	cohort_base
GROUP BY
	cohort_year,
	order_year,
	cohort_index
)

SELECT
	cohort_year,
	order_year,
	cohort_index,
	active_customers,
	((active_customers * 100.0) / FIRST_VALUE(active_customers) OVER(PARTITION BY cohort_year ORDER BY cohort_index)) AS customer_retention,
	revenue,
	((revenue * 100.0) / FIRST_VALUE(revenue) OVER(PARTITION BY cohort_year ORDER BY cohort_index)) AS revenue_retention,
	profit,
	((profit * 100.0) / FIRST_VALUE(profit) OVER(PARTITION BY cohort_year ORDER BY cohort_index)) AS profit_retention
FROM 
	cohort_index_metrics