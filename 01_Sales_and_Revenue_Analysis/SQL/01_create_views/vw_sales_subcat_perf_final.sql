CREATE VIEW vw_sales_subcat_perf_final AS
SELECT 
	yms.order_year,
	yms.categorykey,
	yms.categoryname,
	yms.subcategorykey,
	yms.subcategoryname,
	yms.revenue_per_unit,
	yms.cost_per_unit,
	yms.profit_per_unit,
	yms.revenue_change AS revenu_per_unit_change,
	yms.cost_change AS cost_per_unit_change,
	yms.profit_change AS profit_per_unit_change,
	yms.profit_margin,
	yms.profit_margin_change,
	ymc.revenue_share,
	ymc.revenue_share_change,
	ymc.cost_share,
	ymc.cost_share_change,
	ymc.profit_share,
	ymc.profit_share_change,
	(yms.profit_margin_change * ymc.revenue_share) AS weighted_profit_margin
FROM
	vw_sales_subcat_year_yoy yms
LEFT JOIN
	vw_sales_subcat_year_share_yoy ymc
	ON
	yms.order_year = ymc.order_year AND
	yms.subcategorykey = ymc.subcategorykey