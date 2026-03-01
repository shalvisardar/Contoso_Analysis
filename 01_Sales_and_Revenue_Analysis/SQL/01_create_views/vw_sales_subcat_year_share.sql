CREATE VIEW vw_sales_subcat_year_share AS
WITH year_and_category_values AS(
	SELECT 
		ycv.order_year,
		ycv.categorykey,
		ycv.categoryname,
		ycv.subcategorykey,
		ycv.subcategoryname,
		ycv.quantity,
		(ycv.revenue_per_unit*ycv.quantity) AS category_revenue,
		ydv.total_revenue,
		(ycv.cost_per_unit*ycv.quantity) AS category_cost,
		ydv.total_cost,
		(ycv.profit_per_unit*quantity) AS category_profit,
		ydv.total_profit
	FROM
		vw_sales_subcat_year_lag ycv
	LEFT JOIN
		vw_sales_year_base ydv
		ON
		ycv.order_year = ydv.order_year
)

SELECT
	yacv.order_year,
	yacv.categorykey,
	yacv.categoryname,
	yacv.subcategorykey,
	yacv.subcategoryname,
	((yacv.category_revenue / yacv.total_revenue)*100) AS revenue_share,
	((yacv.category_cost / yacv.total_cost)*100) AS cost_share,
	((yacv.category_profit / yacv.total_profit)*100) AS profit_share
FROM
	year_and_category_values yacv