CREATE VIEW vw_sales_year_base AS
WITH yearly_values AS(
	SELECT
		EXTRACT(YEAR FROM bs.order_date) AS order_year,
		SUM(bs.revenue_usd) AS total_revenue,
		SUM(bs.cost_usd) AS total_cost,
		SUM(bs.profit_usd) AS total_profit,
		COUNT(DISTINCT bs.orderkey) AS no_of_orders,
		COUNT(DISTINCT bs.customerkey) AS no_of_customers
	FROM
		vw_sales_order_base bs
	GROUP BY
		order_year
),
profit_margin_and_aov AS(
	SELECT 
		yv.order_year,
		(yv.total_profit / yv.total_revenue) AS profit_margin,
		(yv.total_revenue / yv.no_of_orders) AS avg_order_value
	FROM
		yearly_values yv
)

SELECT
	yv.*,
	pma.profit_margin,
	pma.avg_order_value 
FROM
	yearly_values yv
LEFT JOIN
	profit_margin_and_aov pma
	ON
	yv.order_year = pma.order_year