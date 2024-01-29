-- Calculation of the cancellation rate for each user by gender.

with a as 
    (SELECT 
        user_id,
        count(distinct order_id) as orders_count,
        round(count(order_id) filter(WHERE action = 'cancel_order')/count(distinct order_id)::decimal, 2) as cancel_rate
    FROM   
        user_actions
    GROUP BY 
        user_id)

SELECT 
    coalesce(sex,'unknown') as sex,
    round(avg(cancel_rate), 3) as avg_cancel_rate
FROM
    (SELECT 
        a.user_id as user_id,
        a.orders_count as orders_count,
        a.cancel_rate as cancel_rate,
        b.sex
    FROM a
    LEFT JOIN 
        users as b 
        using(user_id)
    ) as full_table
GROUP BY 
    sex
ORDER BY 
    sex