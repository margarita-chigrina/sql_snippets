-- Calculation of the cumulative sum

SELECT 
    date,
    orders_count,
    sum(orders_count) OVER (ORDER BY date)::integer as orders_cum_count
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