CREATE VIEW vw_sales_aov_decomp_yoy AS
WITH aov_metrics AS(
	SELECT
		EXTRACT(YEAR FROM bs.order_date) AS order_year,
		(SUM(bs.revenue_usd)/SUM(quantity)) AS price_per_unit,
		((SUM(bs.quantity)*1.0)/COUNT(DISTINCT bs.orderkey)) AS units_per_order
	FROM
		vw_sales_order_base bs
	GROUP BY
		order_year
), aov_metric_changes AS(
	SELECT
		order_year,
		price_per_unit,
		(((price_per_unit - LAG(price_per_unit) OVER(ORDER BY order_year)) / LAG(price_per_unit) OVER(ORDER BY order_year))*100) AS ppu_change,
		units_per_order,
		(((units_per_order - LAG(units_per_order) OVER(ORDER BY order_year)) / LAG(units_per_order) OVER(ORDER BY order_year))*100) AS upo_change
	FROM
		aov_metrics
)

SELECT
	*
FROM
	aov_metric_changes