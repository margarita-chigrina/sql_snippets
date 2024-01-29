-- Calculation of user metrics:
-- Total number of orders
-- Average number of items per order
-- Total value of all purchases
-- Average order value
-- Minimum order value
-- Maximum order value

with order_full_info as (
  SELECT
    a.order_price as order_price,
    b.order_id as order_id,
    b.user_id as user_id,
    b.product_ids as product_ids
  FROM
    (SELECT
        order_id,
        sum(price) as order_price
      FROM
        (SELECT
            a.order_id as order_id,
            a.product_id as product_id,
            b.price as price
          FROM
            (SELECT
                order_id,
                unnest(product_ids) as product_id
              FROM
                orders
            ) as a
            LEFT JOIN products as b ON a.product_id = b.product_id
        ) as full_info_products
      GROUP BY
        order_id
    ) as a
    RIGHT JOIN (
      SELECT
        user_id,
        order_id,
        product_ids
      FROM
        (SELECT
            a.user_id as user_id,
            a.order_id as order_id,
            b.product_ids as product_ids
          FROM
            (SELECT
                DISTINCT user_id,
                order_id
              FROM
                user_actions
              WHERE
                order_id not in (
                  SELECT
                    order_id
                  FROM
                    user_actions
                  WHERE
                    action = 'cancel_order'
                )
            ) as a
            LEFT JOIN orders as b ON a.order_id = b.order_id
          ORDER BY
            user_id,
            order_id
        ) as products_in_orders
    ) as b ON a.order_id = b.order_id
)
SELECT
  user_id,
  count(order_id) as orders_count,
  round(avg(array_length(product_ids, 1)), 2) as avg_order_size,
  sum(order_price) as sum_order_value,
  round(avg(order_price), 2) as avg_order_value,
  min(order_price) as min_order_value,
  max(order_price) as max_order_value
FROM
  order_full_info
GROUP BY
  user_id
ORDER BY
  user_id
limit
  1000