#business objective - we made our 4th product available as a primary product on Dec 5th, 2014.
#pull sales data since then and show how well each product cross-sells from one another


SELECT primary_product_id, COUNT(DISTINCT(primary_product)) AS total_orders,
COUNT(DISTINCT CASE WHEN xsell_product_id = 1 THEN primary_product ELSE NULL END) AS xsold_prod1,
COUNT(DISTINCT CASE WHEN xsell_product_id = 2 THEN primary_product ELSE NULL END) AS xsold_prod2,
COUNT(DISTINCT CASE WHEN xsell_product_id = 3 THEN primary_product ELSE NULL END) AS xsold_prod3,
COUNT(DISTINCT CASE WHEN xsell_product_id = 4 THEN primary_product ELSE NULL END) AS xsold_prod4,
COUNT(DISTINCT CASE WHEN xsell_product_id = 1 THEN primary_product ELSE NULL END)/COUNT(DISTINCT(primary_product)) AS xsell_prod1_rt,
COUNT(DISTINCT CASE WHEN xsell_product_id = 2 THEN primary_product ELSE NULL END)/COUNT(DISTINCT(primary_product)) AS xsell_prod2_rt,
COUNT(DISTINCT CASE WHEN xsell_product_id = 3 THEN primary_product ELSE NULL END)/COUNT(DISTINCT(primary_product)) AS xsell_prod3_rt,
COUNT(DISTINCT CASE WHEN xsell_product_id = 4 THEN primary_product ELSE NULL END)/COUNT(DISTINCT(primary_product)) AS xsell_prod4_rt
FROM(

SELECT primary_products.primary_product_id,  primary_products.order_id AS primary_product, order_items.product_id AS xsell_product_id

FROM(

SELECT primary_product_id, order_id
FROM orders
WHERE created_at > '2014-12-05') AS primary_products

LEFT JOIN order_items
ON order_items.order_id = primary_products.order_id
AND order_items.is_primary_item = 0) AS cross_sell_prod_id

GROUP BY primary_product_id;