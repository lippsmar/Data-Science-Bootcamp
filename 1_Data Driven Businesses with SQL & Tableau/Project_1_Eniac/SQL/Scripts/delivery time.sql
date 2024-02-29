SELECT * FROM magist.orders;

-- What’s the average time between the order being placed and the product being delivered?
SELECT 
    AVG(TIMESTAMPDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date)) AS average_delivery_time
FROM
    orders
WHERE
    order_delivered_customer_date IS NOT NULL
        AND order_purchase_timestamp IS NOT NULL;



-- are orders in estimated time?

SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(*) AS status_count
FROM
    orders
WHERE
    order_delivered_customer_date IS NOT NULL
GROUP BY
    delivery_status;

-- Is there any pattern for delayed orders, e.g. big products being delayed more often?

SELECT 
	price,
    o.order_id,
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On time'
        ELSE 'Delayed'
    END AS delivery_status
FROM
    orders o
        LEFT JOIN
    order_items oi ON o.order_id = oi.order_id

WHERE
    order_delivered_customer_date IS NOT NULL AND price >= 300.0;
    
    
-- Ratio of delayed delivery for prices higher tahan 300€
    SELECT
    delivery_status,
    MAX(price) AS max_price,
    MIN(price) AS min_price,
    AVG(price) AS avg_price,
    COUNT(*) AS order_count
FROM (
    SELECT
        price,
        CASE
            WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On time'
            ELSE 'Delayed'
        END AS delivery_status
    FROM
        orders o
    LEFT JOIN
        order_items oi ON o.order_id = oi.order_id
    WHERE
        order_delivered_customer_date IS NOT NULL AND price >= 300.0
) AS subquery
GROUP BY
    delivery_status;


-- delays of high priced orders by state
SELECT
    state,
    delivery_status,
    MAX(price) AS max_price,
    MIN(price) AS min_price,
    AVG(price) AS avg_price,
    COUNT(*) AS order_count
FROM (
    SELECT
        price,
        CASE
            WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On time'
            ELSE 'Delayed'
        END AS delivery_status,
        g.state
    FROM
        orders o
    LEFT JOIN
        order_items oi ON o.order_id = oi.order_id
    LEFT JOIN
        customers c ON o.customer_id = c.customer_id
	LEFT JOIN
		geo g ON c.customer_zip_code_prefix = g.zip_code_prefix
    WHERE
        order_delivered_customer_date IS NOT NULL AND price >= 300.0
) AS subquery
GROUP BY
    state, delivery_status;

