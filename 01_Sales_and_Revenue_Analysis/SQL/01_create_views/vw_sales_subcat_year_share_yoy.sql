CREATE VIEW vw_sales_subcat_year_share_yoy AS
SELECT
	capcc.order_year,
	capcc.categorykey,
	capcc.categoryname,
	capcc.subcategorykey,
	capcc.subcategoryname,
	capcc.revenue_share,
	(((capcc.revenue_share - capcc.previous_revenue_share) / capcc.previous_revenue_share)*100) AS revenue_share_change,
	capcc.cost_share,
	(((capcc.cost_share - capcc.previous_cost_share) / capcc.previous_cost_share)*100) AS cost_share_change,
	capcc.profit_share,
	(((capcc.profit_share - capcc.previous_profit_share) / capcc.previous_profit_share)*100) AS profit_share_change
FROM
	vw_sales_subcat_year_share_lag capcc 