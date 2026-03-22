CREATE VIEW vw_customer_order_base AS
WITH customer_latest AS (
	SELECT *
	FROM (
		SELECT
			c.*,
			ROW_NUMBER() OVER(
				PARTITION BY c.customerkey
				ORDER BY c.enddt DESC
			) AS rn
		FROM
			customer c
	)
	WHERE
		rn = 1
)

SELECT 
	s.orderkey,
	s.linenumber,
	s.orderdate::DATE AS order_date,
	s.customerkey,
	CONCAT(c.givenname, ' ', c.surname) AS full_name,
	c.gender,
	c.age,
	c.continent,
	c.countryfull,
	c.statefull,
	c.city,
	c.occupation,
	s.storekey,
	s.productkey,
	s.quantity,
	((s.netprice * s.quantity) / s.exchangerate) AS revenue_usd,
	((s.unitcost * s.quantity) / s.exchangerate) AS cost_usd,
	(((s.netprice - s.unitcost) * s.quantity) / s.exchangerate) AS profit_usd
FROM
	sales s
LEFT JOIN
	customer_latest c 
	ON
	s.customerkey = c.customerkey
ORDER BY
	s.orderkey