-- Calculation of the total number of placed orders and the percentage of 
-- canceled orders for each user.

SELECT 
    user_id,
    count(distinct order_id) as orders_count,
    round(count(order_id) filter(WHERE action = 'cancel_order')/count(distinct order_id)::decimal, 2) as cancel_rate
FROM   
    user_actions
GROUP BY 
    user_id 
HAVING 
    count(distinct order_id) > 3 
    and 
    round(count(order_id) filter(WHERE  action = 'cancel_order')/count(distinct order_id)::decimal, 2) >= 0.5
ORDER BY 
    user_id
