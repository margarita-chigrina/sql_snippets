-- Calculation of the moving average of the number of orders
SELECT 
    date,
    orders_count,
    round(avg(orders_count) OVER (ORDER BY date rows between 3 preceding and 1 preceding), 2) as moving_avg
FROM   
    (SELECT 
        creation_time::date as date,
        count(distinct order_id) as orders_count
    FROM
        orders
    WHERE
        order_id not in (SELECT 
                            order_id
                        FROM
                            user_actions
                        WHERE  
                            action = 'cancel_order')
    GROUP BY date) t1