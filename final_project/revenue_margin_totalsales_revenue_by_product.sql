#business objective - pull monthly trend for revenue and margin by product, along with total sales and revenue

SELECT YEAR(order_items.created_at) as yr, MONTH(order_items.created_at) As mo,

       SUM(CASE WHEN products.product_id = 1 THEN order_items.price_usd ELSE NULL END) AS 'Fuzzy Rev',
       SUM(CASE WHEN products.product_id = 1 THEN order_items.price_usd ELSE NULL END) - SUM(CASE WHEN products.product_id = 1 THEN order_items.cogs_usd ELSE NULL END) AS 'Fuzzy Margin',
       SUM(CASE WHEN products.product_id = 2 THEN order_items.price_usd ELSE NULL END) AS 'Forever Love Rev',
              SUM(CASE WHEN products.product_id = 2 THEN order_items.price_usd ELSE NULL END) - SUM(CASE WHEN products.product_id = 2 THEN order_items.cogs_usd ELSE NULL END) 'Forever Love Margin',
       SUM(CASE WHEN products.product_id = 3 THEN order_items.price_usd ELSE NULL END) AS 'Birthday Panda Rev',
       SUM(CASE WHEN products.product_id = 3 THEN order_items.price_usd ELSE NULL END) - SUM(CASE WHEN products.product_id = 3 THEN order_items.cogs_usd ELSE NULL END) AS 'Birthday Panda Margin',
       SUM(CASE WHEN products.product_id = 4 THEN order_items.price_usd ELSE NULL END) AS 'Hudson River Bear Rev',
       SUM(CASE WHEN products.product_id = 4 THEN order_items.price_usd ELSE NULL END) - SUM(CASE WHEN products.product_id = 4 THEN order_items.cogs_usd ELSE NULL END) AS 'Hudson River Bear Margin',
       SUM(price_usd) AS revenue,
       SUM(price_usd - order_items.cogs_usd) AS margin
FROM order_items
LEFT JOIN products
ON products.product_id = order_items.product_id
GROUP BY YEAR(order_items.created_at), MONTH(order_items.created_at);
