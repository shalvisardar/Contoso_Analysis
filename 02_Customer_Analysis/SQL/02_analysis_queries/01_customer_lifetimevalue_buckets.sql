CREATE VIEW vw_01_customer_lifetimevalue_buckets AS
SELECT
	CASE
		WHEN vcm.lifespan_days = 0 THEN '0 - (One-Time)'
		WHEN vcm.lifespan_days <= 365 THEN '1 - (< 1 Year)'
		WHEN vcm.lifespan_days <= 1095 THEN '2 - (1-3 Years)'
		WHEN vcm.lifespan_days <= 1826 THEN '3 - (3-5 Years)'
		WHEN vcm.lifespan_days <= 2555 THEN '4 - (5-7 Years)'
		ELSE '5 - (7+ Years)'
	END AS lifetime_bucket,
	COUNT(*) AS num_customers,
	(COUNT(*) / SUM(COUNT(*)) OVER())*100 AS customer_share
FROM
	analytics.vw_customer_metrics vcm
GROUP BY
	lifetime_bucket
ORDER BY
	lifetime_bucket