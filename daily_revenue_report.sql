-- Calculating the daily revenue of the service

with products_prices as 
    (SELECT 
        a.order_id as order_id,
        a.creation_time:: date as date,
        a.product_id as product_id,
        b.price as price
    FROM   
        (SELECT order_id,
                creation_time,
                unnest(product_ids) as product_id
        FROM   
            orders
        WHERE  
            order_id not in 
                            (SELECT 
                                order_id
                            FROM  
                                user_actions
                            WHERE  
                                action = 'cancel_order')) as a
    LEFT JOIN 
        products as b
        ON a.product_id = b.product_id)

SELECT 
    date,
    sum(price)::decimal as revenue
FROM   
    products_prices
GROUP BY 
    date
ORDER BY 
    date