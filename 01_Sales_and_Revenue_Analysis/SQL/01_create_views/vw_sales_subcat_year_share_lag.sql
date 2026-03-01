CREATE VIEW vw_sales_subcat_year_share_lag AS 
SELECT
	ccy.order_year,
	ccy.categorykey,
	ccy.categoryname,
	ccy.subcategorykey,
	ccy.subcategoryname,
	ccy.revenue_share,
	LAG(ccy.revenue_share) OVER(PARTITION BY ccy.subcategorykey ORDER BY ccy.order_year) AS previous_revenue_share,
	ccy.cost_share,
	LAG(ccy.cost_share) OVER(PARTITION BY ccy.subcategorykey ORDER BY ccy.order_year) AS previous_cost_share,
	ccy.profit_share,
	LAG(ccy.profit_share) OVER(PARTITION BY ccy.subcategorykey ORDER BY ccy.order_year) AS previous_profit_share
FROM
	vw_sales_subcat_year_share ccy