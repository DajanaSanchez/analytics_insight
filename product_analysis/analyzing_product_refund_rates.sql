#business objective - Mr.Fuzzy supplier had some quality issues which weren't corrected until Sept. 2013.
#Then they had a major problem where the bear's arms were falling off in Aug/Sept 2014. As a result, we replaced them with a new supplier on Sept 16, 2014.
#We need to pull monthly product refund rates, by product, and confirm that quality control issues were fixed.
#Data through Oct, 15, 2014.

SELECT MIN(DATE(order_items.created_at)) AS month_to_month,
       COUNT(DISTINCT CASE WHEN order_items.product_id = '1' THEN order_items.order_item_id ELSE NULL END) AS product_1_orders,
       COUNT(DISTINCT CASE WHEN order_items.product_id = '1' THEN order_item_refunds.order_item_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN order_items.product_id = '1' THEN order_items.order_item_id ELSE NULL END) AS product1_refund_rate,

       COUNT(DISTINCT CASE WHEN order_items.product_id = '2' THEN order_items.order_id ELSE NULL END) AS product_2_orders,
       COUNT(DISTINCT CASE WHEN order_items.product_id = '2' THEN order_item_refunds.order_item_id ELSE NULL END)/ COUNT(DISTINCT CASE WHEN order_items.product_id = '2' THEN order_items.order_item_id ELSE NULL END) AS product2_refund_rate,

       COUNT(DISTINCT CASE WHEN order_items.product_id = '3' THEN order_items.order_id ELSE NULL END) AS product_3_orders,
       COUNT(DISTINCT CASE WHEN order_items.product_id = '3' THEN order_item_refunds.order_item_id ELSE NULL END)/ COUNT(DISTINCT CASE WHEN order_items.product_id = '3' THEN order_items.order_item_id ELSE NULL END) AS product3_refund_rate,

       COUNT(DISTINCT CASE WHEN order_items.product_id = '4' THEN order_items.order_id ELSE NULL END) AS product_4_orders,
       COUNT(DISTINCT CASE WHEN order_items.product_id = '4' THEN order_item_refunds.order_item_id ELSE NULL END)/ COUNT(DISTINCT CASE WHEN order_items.product_id = '4' THEN order_items.order_item_id ELSE NULL END) AS product4_refund_rate

FROM order_items
LEFT JOIN order_item_refunds
ON order_items.order_item_id = order_item_refunds.order_item_id
WHERE order_items.created_at < '2014-10-15'
GROUP BY YEAR(order_items.created_at), MONTH(order_items.created_at)
