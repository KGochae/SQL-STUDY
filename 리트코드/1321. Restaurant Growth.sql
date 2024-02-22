
WITH cte as(
SELECT visited_on
    , min(visited_on) over() as first_day
    , SUM(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS AMOUNT
    , ROUND(SUM(amount) OVER(ORDER BY visited_on RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW) / 7, 2) AS AVERAGE_AMOUNT
    
FROM (SELECT visited_on
            , SUM(amount) as amount
     FROM CUSTOMER
     GROUP BY visited_on) A
)

SELECT visited_on
    ,amount
    ,average_amount
FROM CTE
where datediff(visited_on, first_day)>=6

-- 쉽지 않은 문제였습니다.
-- visted_on 을 기준으로 6일 전의 amount 합계, 평균을 구해야하는 문제 입니다.
-- 데이터가 2020-01-01 ~ 2020-01-10 까지 있었고 중복 된 날짜도 있었기 때문에 나름 조건 처리가 필요했습니다.

-- ROWS BETWEEN PRECEDING 이라는 것을 새로 알게 되었네요! 행과 행 혹은 날짜 사이의 어떤 기준을 정해서 원하는 구간에 집계함수를 때려 넣을 수 있는 조건!
-- window function 은 계속해서 공부해야겠습니다
