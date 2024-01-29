-- Calculation of the number of first orders made by users on each date 

SELECT 
    time::date as date,
    count(*) as first_orders
FROM   
    (SELECT 
        user_id,
        min(time) as time
    FROM   
        user_actions
    WHERE  
        order_id not in 
                        (SELECT 
                            order_id
                        FROM   
                            user_actions
                        WHERE  
                            action = 'cancel_order')
    GROUP BY 
        user_id) users_first_orders
GROUP BY 
    date
ORDER BY 
    date