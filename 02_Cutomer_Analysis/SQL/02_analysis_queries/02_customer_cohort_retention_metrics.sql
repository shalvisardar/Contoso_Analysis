SELECT
 vccr.cohort_year,
 vccr.order_year,
 vccr.cohort_index,
 ROUND((vccr.customer_retention)::NUMERIC, 2) AS customer_retention,
 ROUND((vccr.revenue_retention)::NUMERIC, 2) AS revenue_retention,
 ROUND((vccr.profit_retention)::NUMERIC, 2) AS profit_retention 
FROM 
	analytics.vw_customer_cohort_retention vccr