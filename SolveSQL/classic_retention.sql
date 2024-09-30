# A 테이블은 각 고객의 첫주문날짜와, 주문날짜가 있는 테이블
# 가령 a-123 고객의 첫주문이 1월이고, 2월에도 구매를 했다면 first_order_month에 1을 더한 값이 order_month에 해당할 것 -> 이런 customer_id를 count 해야함 (A 서브쿼리)
# 첫주문 이후 두번째 달에도 구매한 고객이 되므로 month1에 집계가 될것임
# 1월에 첫주문 고객의수 - 그 다음달에도 구매 -> 1월 + 1 
# 2월에 첫주문 고객의수 - 그 다음달에도 구매 -> 1월 + 2


SELECT first_order_date 
      , count(distinct customer_id) AS MONTH0
      , count(distinct CASE WHEN DATE_ADD(first_order_date, INTERVAL 1 MONTH) = order_date THEN customer_id END) AS MONTH1
      , count(distinct CASE WHEN DATE_ADD(first_order_date, INTERVAL 2 MONTH) = order_date THEN customer_id END) AS MONTH2
      , count(distinct CASE WHEN DATE_ADD(first_order_date, INTERVAL 3 MONTH) = order_date THEN customer_id END) AS MONTH3
      , count(distinct CASE WHEN DATE_ADD(first_order_date, INTERVAL 4 MONTH) = order_date THEN customer_id END) AS MONTH4
      , count(distinct CASE WHEN DATE_ADD(first_order_date, INTERVAL 5 MONTH) = order_date THEN customer_id END) AS MONTH5

FROM (SELECT customer_id 
              , DATE_FORMAT(order_date,'%Y-%m-01') as order_date
              , DATE_FORMAT(MIN(order_date) OVER(PARTITION BY customer_id),'%Y-%m-01') as first_order_date
        FROM records ) A --  각 고객의 첫주문날짜와, 주문날짜가 있는 테이블
GROUP BY first_order_date
