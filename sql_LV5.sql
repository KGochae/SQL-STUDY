# 프로그래머스 

> LV5.상품을 구매한 회원 비율 구하기
> 2021년에 상품을 구매한 회원수 와 구매한 회원의 비율을 구하는 문제입니다.  = (2021년에 가입한 회원중 상품을 구매한 회원수) / (2021년에 가입한 전체 회원수)
> 년기준 오름차순, 월기준 오름차순

  
# USER_INFO 테이블에서 필요한 정보는 2021년에 가입한 user_id 와 , 총 몇명인지 CNT
# 총몇명이 158명인 것을 알았으니 메모 해두었습니다.

  with info as (
        SELECT user_id
            , COUNT(*) OVER() AS CNT
        FROM USER_INFO
        WHERE YEAR(joined) ='2021'
        )


# ONLINE_SALE 테이블에는 구매이력이 담겨져 있습니다. 문제를 풀기 위해 가장 먼저 접근 한 것은
# 서브쿼리로 만들어 놓은 info 테이블을 이용하여 , 2021년에 가입한 user_info 들만 가져옵니다. (WHERE)
# 문제에서 원하는 TABLE 결과에 맞게 구입한 날짜의 YEAR, MONTH를 추출해주고
# YEAR 과 MONTH를 기준으로 GROUP BY 해줍니다.
# 그리고 DISTINCT 한 USER_ID를 COUNT 해주면 = '2021년에 가입한 회원중 상품을 구매한 회원수' 가 됩니다. 
# 해당 값들을 2021년 가입한 전체회원수 = 158 을 나눠주었습니다. 
  
  SELECT 
     YEAR(sales_date) as YEAR
    , MONTH(sales_date) as MONTH
    , COUNT(DISTINCT user_id)  as PUCAHSED_USERS
    , ROUND(COUNT(DISTINCT user_id) / 158 ,1) as PUCHASED_RATIO
FROM ONLINE_SALE 
WHERE user_id in (select user_id from info ) 
GROUP BY YEAR, MONTH
ORDER BY YEAR, MONTH



