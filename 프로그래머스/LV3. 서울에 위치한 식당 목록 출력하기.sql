# 서울에 위치한 식당들의 식당 ID, 식당 이름, 음식 종류, 즐겨찾기수, 주소, 리뷰 평균 점수를 조회
# REST_INFO -  REST_ID, REST_NAME, FOOD_TYPE, FAVORITES, ADDRESS
# REST_REVIEW - REST_ID, REVIEW_SCORE
# 리뷰평균점수 소수점 3번째 자리 (컬럼명: SCORE)
# 평균점수 내림차순, 즐겨찾기 내림차순


--  첫번째 접근 방법) 선 REVIEW SCORE 평균을 구한 뒤, 해당 조건에 맞게 결합

WITH SCORE AS (SELECT REST_ID
                        , ROUND(AVG(REVIEW_SCORE),2) as SCORE
                  FROM REST_REVIEW
                  GROUP BY REST_ID)


SELECT A.REST_ID
    , A.REST_NAME
    , A.FOOD_TYPE
    , A.FAVORITES
    , A.ADDRESS
    , S.SCORE
FROM REST_INFO A
INNER JOIN SCORE S ON A.REST_ID = S.REST_ID 
WHERE A.ADDRESS LIKE '서울%'
ORDER BY SCORE DESC, FAVORITES DESC


-- 두번째 방법) 일단 REVIEW 데이터와 다 결합한뒤, 후 평균 SCORE 집계

SELECT REST_ID
    , REST_NAME
    , FOOD_TYPE
    , FAVORITES
    , ADDRESS
    , round(avg(REVIEW_SCORE),2)  AS  SCORE
FROM REST_INFO i JOIN REST_REVIEW r USING (REST_ID)
WHERE ADDRESS LIKE '서울%'
GROUP BY REST_ID
order by SCORE desc, FAVORITES desc


> 얻어가는 부분!
> 테이블을 JOIN 할 때 ON 만 사용하는줄 알았는데 결합할 기준이 되는 COLUMN 명이 같을 때는 USING 을 이용한다는것을 알았다 🤔



