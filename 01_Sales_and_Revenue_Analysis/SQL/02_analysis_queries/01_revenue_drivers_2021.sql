WITH ranked_subcategories AS(
	SELECT
		ymc.subcategorykey,
		ymc.revenue_share,
		RANK() OVER(ORDER BY ymc.revenue_share DESC) AS revenue_rank
	FROM
		vw_sales_subcat_year_share_yoy ymc 
	WHERE
		ymc.order_year = 2021
)

SELECT
	yms.order_year,
	yms.categoryname,
	ymc.subcategorykey,
	yms.subcategoryname,
	yms.revenue_per_unit,
	yms.cost_per_unit,
	ymc.revenue_share,
	ymc.cost_share,
	yms.revenue_change,
	yms.cost_change,
	ymc.revenue_share_change,
	ymc.cost_share_change,
	yms.profit_margin_change
FROM 
	vw_sales_subcat_year_yoy yms
LEFT JOIN
	vw_sales_subcat_year_share_yoy ymc
	ON
	yms.order_year = ymc.order_year AND
	yms.subcategorykey = ymc.subcategorykey
LEFT JOIN
	ranked_subcategories rs
	ON
	yms.subcategorykey = rs.subcategorykey
WHERE
	ymc.order_year IN (2021, 2022)
ORDER BY
	rs.revenue_rank,
	ymc.order_year
LIMIT
	10