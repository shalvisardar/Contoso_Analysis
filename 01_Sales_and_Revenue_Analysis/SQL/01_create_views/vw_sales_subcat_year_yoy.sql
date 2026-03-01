CREATE VIEW vw_sales_subcat_year_yoy AS
SELECT 
	ycv.order_year,
	ycv.categorykey,
	ycv.categoryname,
	ycv.subcategorykey,
	ycv.subcategoryname,
	ycv.revenue_per_unit,
	(((ycv.revenue_per_unit - ycv.previous_revenue) / ycv.previous_revenue)*100) AS revenue_change,
	ycv.cost_per_unit,
	(((ycv.cost_per_unit - ycv.previous_cost) / ycv.previous_cost)*100) AS cost_change,
	ycv.profit_per_unit,
	(((ycv.profit_per_unit - ycv.previous_profit) / ycv.previous_profit)*100) AS profit_change,
	ycv.profit_margin,
	(((ycv.profit_margin - ycv.previous_profit_margin) / ycv.previous_profit_margin)*100) AS profit_margin_change
FROM
	vw_sales_subcat_year_lag ycv