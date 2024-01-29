-- Calculation of Average Product Prices by Title

SELECT 
    round(avg(price), 2) as avg_price
FROM   
    products
WHERE  name like 'tea %'
    or name like '%coffee%'