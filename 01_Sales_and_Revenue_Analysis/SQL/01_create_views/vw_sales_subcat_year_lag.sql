CREATE VIEW vw_sales_subcat_year_lag AS
WITH yearly_category_values AS(
	SELECT 
		EXTRACT(YEAR FROM bs.order_date) AS order_year,
		SUM(bs.quantity) AS quantity,
		p.categorykey,
		p.categoryname,
		p.subcategorykey,
		p.subcategoryname,
		(SUM(bs.revenue_usd)/SUM(bs.quantity)) AS revenue_per_unit,
		(SUM(bs.cost_usd)/SUM(bs.quantity)) AS cost_per_unit,
		(SUM(bs.profit_usd)/SUM(bs.quantity)) AS profit_per_unit
	FROM 
		vw_sales_order_base bs
	LEFT JOIN
		product p
		ON
		bs.productkey = p.productkey
	GROUP BY
		order_year,
		p.categorykey,
		p.categoryname,
		p.subcategorykey,
		p.subcategoryname
)

SELECT
	order_year,
	categorykey,
	categoryname,
	subcategorykey,
	subcategoryname,
	quantity,
	revenue_per_unit,
	LAG(revenue_per_unit) OVER(PARTITION BY subcategorykey ORDER BY order_year) AS previous_revenue,
	cost_per_unit,
	LAG(cost_per_unit) OVER(PARTITION BY subcategorykey ORDER BY order_year) AS previous_cost,
	profit_per_unit,
	LAG(profit_per_unit) OVER(PARTITION BY subcategorykey ORDER BY order_year) AS previous_profit,
	((profit_per_unit / revenue_per_unit)*100) AS profit_margin,
	LAG(((profit_per_unit / revenue_per_unit)*100)) OVER(PARTITION BY subcategorykey ORDER BY order_year) AS previous_profit_margin
FROM 
	yearly_category_values