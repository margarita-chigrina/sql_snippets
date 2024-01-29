-- Calculation of the share of first-time and repeat orders for each date.
SELECT 
    date,
    order_type,
    count(order_id) as orders_count,
    round(count(order_id)/sum(count(order_id)) OVER(PARTITION BY date), 2) as orders_share
FROM   
    (SELECT 
        time::date as date,
        order_id,
        case 
            when time = min(time) OVER(PARTITION BY user_id) then 'Первый'
            else 'Повторный' 
        end as order_type
    FROM   
        user_actions
    WHERE  
        order_id not in (SELECT 
                            order_id
                        FROM   
                            user_actions
                        WHERE  
                            action = 'cancel_order')) t1
GROUP BY 
    date, 
    order_type
ORDER BY 
    date, 
    order_type
