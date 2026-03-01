CREATE VIEW vw_sales_year_yoy AS
WITH previous_yearly_values AS(
	SELECT
		ydv.order_year,
		ydv.total_revenue,
		LAG(ydv.total_revenue) OVER(ORDER BY ydv.order_year) AS previous_revenue,
		ydv.total_cost,
		LAG(ydv.total_cost) OVER(ORDER BY ydv.order_year) AS previous_cost,
		ydv.total_profit,
		LAG(ydv.total_profit) OVER(ORDER BY ydv.order_year) AS previous_profit,
		ydv.no_of_orders,
		LAG(ydv.no_of_orders) OVER(ORDER BY ydv.order_year) AS previous_no_of_orders,
		ydv.no_of_customers,
		LAG(ydv.no_of_customers) OVER(ORDER BY ydv.order_year) AS previous_no_of_customers,
		ydv.profit_margin,
		LAG(ydv.profit_margin) OVER(ORDER BY ydv.order_year) AS previous_profit_margin,
		ydv.avg_order_value,
		LAG(ydv.avg_order_value) OVER(ORDER BY ydv.order_year) AS previous_avg_order_value
	FROM
		vw_sales_year_base ydv
), 
yearly_changes AS(
	SELECT
		pyv.order_year,
		pyv.total_revenue,
		(((pyv.total_revenue - pyv.previous_revenue) / pyv.previous_revenue)*100) AS revenue_change,
		pyv.total_cost,
		(((pyv.total_cost - pyv.previous_cost) / pyv.previous_cost)*100) AS cost_change,
		pyv.total_profit,
		(((pyv.total_profit - pyv.previous_profit) / pyv.previous_profit)*100) AS profit_change,
		pyv.no_of_orders,
		((((pyv.no_of_orders*1.0) - pyv.previous_no_of_orders) / pyv.previous_no_of_orders)*100) AS no_of_orders_change,
		pyv.no_of_customers,
		((((pyv.no_of_customers*1.0) - pyv.previous_no_of_customers) / pyv.previous_no_of_customers)*100) AS no_of_customer_change,
		pyv.profit_margin,
		(((pyv.profit_margin - pyv.previous_profit_margin) / pyv.previous_profit_margin)*100) AS profit_margin_change,
		pyv.avg_order_value,
		(((pyv.avg_order_value - pyv.previous_avg_order_value) / pyv.previous_avg_order_value)*100) AS average_order_value_change
	FROM
		previous_yearly_values pyv
)

SELECT
	*
FROM
	yearly_changes