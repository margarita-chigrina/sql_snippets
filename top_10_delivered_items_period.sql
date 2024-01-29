--Determining the most popular items delivered in a specific period.

with products_in_order as 
   (SELECT 
      a.order_id as order_id,
      a.product_id as product_id,
      b.name as name
   FROM  
      (SELECT 
         DISTINCT order_id,
         unnest(product_ids) as product_id
      FROM   
         orders
      WHERE  
         order_id not in 
                        (SELECT 
                           order_id
                        FROM   
                           user_actions
                        WHERE  
                           action = 'cancel_order')
                           and order_id in 
                                          (SELECT 
                                             order_id
                                          FROM  
                                             courier_actions
                                          WHERE  
                                             action = 'deliver_order'
                                             and date_part('month', time) = 09
                                             and date_part('year', time) = 2022)) a
   LEFT JOIN 
      products as b 
      using(product_id))
   
SELECT 
   name,
   count(*) as times_purchased
FROM 
   products_in_order
GROUP BY 
   name
ORDER BY
   times_purchased desc 
limit 10
