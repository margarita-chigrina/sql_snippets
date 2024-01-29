-- Calculation of the average time between orders for each user

with full_table as 
    (SELECT 
        DISTINCT 
        user_id,
        order_id,
        time,
        row_number() OVER(PARTITION BY user_id ORDER BY time) as order_number,
        count(order_id) OVER (PARTITION BY user_id) as total_orders,
        lag(time, 1) OVER(PARTITION BY user_id ORDER BY time) as time_lag,
        time - lag(time, 1) OVER(PARTITION BY user_id ORDER BY time) as time_diff
    FROM   
        user_actions
    WHERE  
        order_id not in (SELECT 
                            order_id 
                        FROM   
                            user_actions 
                        WHERE  
                            action = 'cancel_order'))

SELECT 
    user_id,
    round(avg(extract(epoch FROM time_diff)/3600))::integer as hours_between_orders
FROM   
    full_table
WHERE  
    total_orders > 1
GROUP BY 
    user_id
ORDER BY 
    user_id 