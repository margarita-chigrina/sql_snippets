-- Counting Users in Each Age Group Based on Gender

SELECT 
    date_part('year', age(current_date, birth_date))::integer as age,
    sex,
    count(user_id) as users_count
FROM   
    users
WHERE  
    birth_date is not null
GROUP BY 
    age, 
    sex
ORDER BY 
    age, 
    sex