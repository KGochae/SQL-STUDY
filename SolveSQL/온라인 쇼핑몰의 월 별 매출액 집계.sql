# 월 별 매출 규모를 구해야합니다.
# 총3개의 컬럼이 결과로 나와야 합니다.
# 자세한 내용은 문제의 링크에 있습니다! (https://solvesql.com/problems/shoppingmall-monthly-summary/)
  
> 1. 취소 주문을 제외한 주문 금액 함계 (order_id = C 로시작하면 취소된거임) order_id like ('C%')
> 2. 취소 주문의 금액 합계
> 3. 총합계

# PRICE 테이블
# 먼저 order_items 테이블에 있는 order_id 별로 제품의 가격 * 수량을 계산하여 total_price를 구해주었습니다.
# 또한 취소한 금액 정보가 필요하기 때문에, cancel 이라는 컬럼을 추가하여 취소 주문된 값들을 따로 구분하는 방법을 생각했습니다. (cancel = 1 인 경우 취소한 고객입니다.)
  
with PRICE AS (
SELECT order_id
    , cancel
    , sum(total_price) as sum_price
FROM (SELECT order_id
            , CASE WHEN order_id like('C%') THEN 1 ELSE 0 END AS cancel
            , price * quantity as total_price
        FROM order_items) A
GROUP BY order_id,cancel),

  
# AGGREGATED 테이블
# 위 price 테이블과 날짜별 order_id 정보가 있는 order 테이블을 join 해주었습니다. 월별로 집계해야 하기 때문이죠 (이를 위해, DATE_FORMAT을 월별로 바꿔주었습니다.)
# 그리고 PRICE 테이블에서 만들어놓은 cancel 이용하여 월별 orderd_amount (주문 금액)을 집계했습니다.
# 너무 복잡하게 생각한걸까요.. 더좋은 쿼리방법이 있는지 생각해 봐야겠습니다 ㅠㅠ

AGGREGATED AS (
    SELECT 
        DATE_FORMAT(O.order_date, '%Y-%m') AS order_month,
        CASE WHEN P.cancel = 0 THEN SUM(P.sum_price) ELSE 0 END AS ordered_amount,
        CASE WHEN P.cancel = 1 THEN SUM(P.sum_price) ELSE 0 END AS canceled_amount
    FROM orders O
    LEFT JOIN PRICE P ON O.order_id = P.order_id
    GROUP BY DATE_FORMAT(O.order_date, '%Y-%m'), P.cancel
)

SELECT 
    order_month,
    SUM(ordered_amount) AS ordered_amount,
    SUM(canceled_amount) AS canceled_amount,
    SUM(ordered_amount) + SUM(canceled_amount) AS total_amount
FROM AGGREGATED
GROUP BY order_month
ORDER BY order_month
