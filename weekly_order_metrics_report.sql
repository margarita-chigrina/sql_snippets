-- Calculation for each day of the week:

-- Total number of processed orders.
-- Total number of canceled orders.
-- Total number of orders not canceled (i.e., delivered).
-- Proportion of orders not canceled in the overall order count (success rate).

SELECT 
    date_part('isodow', time)::integer as weekday_number,
    to_char(time, 'Dy') as weekday,
    count(distinct order_id) filter(WHERE action = 'create_order') as created_orders,
    count(distinct order_id) filter(WHERE action = 'cancel_order') as canceled_orders,
    count(distinct order_id) filter(WHERE action = 'create_order')-count(distinct order_id) filter(WHERE action = 'cancel_order') as actual_orders,
    round((count(distinct order_id) filter(WHERE action = 'create_order')-count(distinct order_id) filter(WHERE action = 'cancel_order'))/count(distinct order_id) filter(WHERE action = 'create_order')::decimal, 3) as success_rate
FROM   
    user_actions
WHERE  
    time >= '2022-08-24'
    and 
    time <= '2022-09-06'
GROUP BY 
    weekday_number, 
    weekday
ORDER BY 
    weekday_number
