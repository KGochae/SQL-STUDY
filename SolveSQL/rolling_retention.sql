# 주문 시점이 last_order_month 이하인 경우 모두 count 되도록 집계
# 예를들어, a유저가 1월에 구입하고 2월,3월에 구입을 안했지만 4월에 구입했다면  -> 1,2,3,4 모두 count 되도록
# 즉, last_order_month가 기준이 되도록 쿼리를 짜야함 

SELECT first_order_month
    , COUNT(DISTINCT customer_id) month0
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 1 MONTH) <= last_order_month THEN customer_id END) AS month1
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 2 MONTH) <= last_order_month THEN customer_id END) AS month2
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 3 MONTH) <= last_order_month THEN customer_id END) AS month3
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 4 MONTH) <= last_order_month THEN customer_id END) AS month4
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 5 MONTH) <= last_order_month THEN customer_id END) AS month5

FROM (SELECT customer_id  
            , DATE_FORMAT(order_date,'%Y-%m-01') as order_month
            , DATE_FORMAT(MIN(order_date) OVER (PARTITION BY customer_id),'%Y-%m-01') as first_order_month
            , DATE_FORMAT(MAX(order_date) OVER (PARTITION BY customer_id),'%Y-%m-01') as last_order_month
      FROM records) A -- 고객 주문 테이블(주문일, 첫주문일, 마지막주문일)
GROUP BY first_order_month
