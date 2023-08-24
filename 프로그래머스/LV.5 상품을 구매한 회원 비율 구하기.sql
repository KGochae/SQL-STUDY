
# -------------------------- 첫번째 시도 답 ---------------------------#

# 2021 전체 가입자수 158명
, joined AS ( SELECT user_id
                    , joined
                    , COUNT(*) OVER() AS CNT
                FROM USER_INFO
                WHERE joined like '%2021%')
                
# 2021년에 가입했고, 구매를 한사람들의 비율

SELECT YEAR
    , MONTH
    , PUCHASED_USERS
    , ROUND(PUCHASED_USERS/CNT,1) AS PUCHASED_RATIO
FROM (SELECT YEAR
        , MONTH
        , COUNT(DISTINCT USER_ID)AS PUCHASED_USERS
        , CNT
    FROM (SELECT a.user_id
            ,  b.sales_amount
            ,  a.cnt
            ,  DATE_FORMAT(b.sales_date, '%Y') AS YEAR
            ,  DATE_FORMAT(b.sales_date, '%m') AS MONTH
          FROM  joined a
            LEFT JOIN  online_sale b ON a.user_id = b.user_id ) A 
    WHERE YEAR IS NOT NULL
    GROUP BY YEAR,MONTH  ) B
ORDER BY YEAR, MONTH

# -------------------------------- 두번재 시도 답 -------------------------# 
  
> 서브쿼리들을 조금 줄이고, join 하지 않고 구할 수 있을까 고민해보았습니다.
> 코드가 조금 줄었지만 총몇명을 직접 구해서 158로 적은게 별로 섹시하지 않은 접근법 같네요🤤;;;;ㅋㅋㅋㅋㅋㅋ

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
