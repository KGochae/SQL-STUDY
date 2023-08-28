#  HISTORY 기준으로 사용 기간과 요금을 한테이블로 결합

with truck AS (
        SELECT a.history_id AS HISTORY_ID
            , a.car_id
            , b.car_type
            , b.daily_fee
            , DATEDIFF(end_date, start_date)+1 as daydiff # +1 을 해야한다! 2022-08-03 ~ 2022-08-04 인 경우 총2일 
        FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY  a
            LEFT JOIN CAR_RENTAL_COMPANY_CAR b ON a.car_id = b.car_id
            )

SELECT *
FROM truck

# 트럭인경우 / 할인율 적용 7일 이상 5% / 30일 이상 8% / 90일 이상 15% 

SELECT HISTORY_ID
    , ROUND(CASE WHEN daydiff < 7 THEN daily_fee*daydiff
                 WHEN daydiff < 30 THEN (daily_fee-(daily_fee*0.05))*daydiff
                 WHEN daydiff < 90 THEN (daily_fee-(daily_fee*0.08))*daydiff 
                 ELSE (daily_fee-(daily_fee*0.15))*daydiff END,0)  AS FEE 
FROM truck
WHERE car_type ='트럭'
ORDER BY FEE DESC , HISTORY_ID DESC
