--  식품분류별로 가격이 제일 비싼 식품의 분류, 가격, 이름을 조회
--  식품분류가 '과자', '국', '김치', '식용유'인 경우만 출력
--  가격 기준 내림차순


SELECT CATEGORY
    ,PRICE as MAX_PRICE
    ,PRODUCT_NAME
FROM(SELECT CATEGORY
            , PRODUCT_NAME
            , PRICE
            , RANK() OVER(PARTITION BY CATEGORY ORDER BY PRICE DESC) AS rnk
        FROM FOOD_PRODUCT
        WHERE CATEGORY IN ('과자','국','김치','식용유')
        GROUP BY CATEGORY,PRODUCT_NAME
        ORDER BY CATEGORY, PRICE DESC) as A
WHERE  rnk = 1
ORDER BY PRICE DESC


> 문제의 핵심! CATEGORY 별 PRICE 가 높은순으로 데이터를 정렬하고 
> 윈도우함수 RANK를 이용하여 CATEGORY 별 RPCIE가 가장 높은행에 순위를 매긴다.
> RNK = 1에 해당하는 데이터만 추출하면 완성
