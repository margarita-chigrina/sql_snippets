-- Calculation of undelivered orders with a breakdown into canceled orders 
-- and orders that have not been canceled (and consequently, have not been 
-- delivered yet).

SELECT 
    count(distinct order_id) as orders_undelivered,
    count(distinct order_id) filter (WHERE action = 'cancel_order') as orders_canceled,
    count(distinct order_id) - count(distinct order_id) filter (WHERE action = 'cancel_order') as orders_in_process
FROM   
    user_actions
WHERE  
    order_id in 
                (SELECT 
                    order_id
                FROM   
                    courier_actions
                WHERE  
                    order_id not in 
                                    (SELECT 
                                        order_id
                                    FROM   
                                        courier_actions
                                    WHERE  
                                        action = 'deliver_order'))
