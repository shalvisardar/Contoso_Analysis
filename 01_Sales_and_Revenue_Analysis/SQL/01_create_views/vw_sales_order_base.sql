CREATE VIEW vw_sales_order_base AS
SELECT
	orderkey,
	linenumber,
	quantity,
	orderdate::DATE AS order_date,
	customerkey,
	storekey,
	productkey,
	((netprice * quantity) / exchangerate) AS revenue_usd,
	((unitcost * quantity) / exchangerate) AS cost_usd,
	(((netprice - unitcost) * quantity) / exchangerate) AS profit_usd
FROM
	sales