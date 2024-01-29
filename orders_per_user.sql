-- Calculation of Orders per User

SELECT 
    count(distinct user_id) as unique_users,
    count(distinct order_id) as unique_orders,
    round(count(distinct order_id)/count(distinct user_id)::decimal, 2) as orders_per_user
FROM   
    user_actions
WHERE order_id not in 
                    (SELECT 
                        order_id
                    FROM   
                        user_actions
                    WHERE  
                        action = 'cancel_order')