CREATE VIEW vw_05_customer_rfm_segment_migration AS
WITH segment_migration AS(
SELECT 
	vcmb.customerkey,
	vcmb.order_year,
	LAG(vcmb.customer_segment) OVER(
		PARTITION BY vcmb.customerkey 
		ORDER BY vcmb.order_year
	) AS previous_segment,
	vcmb.customer_segment
FROM
	analytics.vw_customer_migration_base vcmb 
),
segment_migration_count AS(
	SELECT 
		previous_segment,
		customer_segment,
		COUNT(DISTINCT customerkey) AS num_customers
	FROM 
		segment_migration 
	WHERE
		previous_segment IS NOT NULL
	GROUP BY
		previous_segment,
		customer_segment
)

SELECT
	previous_segment,
	customer_segment,
	num_customers,
	ROUND((num_customers / SUM(num_customers) OVER(
		PARTITION BY previous_segment
	) * 100)::NUMERIC, 2) AS percent_customers
FROM 
	segment_migration_count 