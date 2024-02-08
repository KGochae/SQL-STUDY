# 8월~10월 까지 기간중 - 조건(1)
# 총 대여 횟수가 5회 이상 자동차들을 - 조건(2)
# 월별 자동차 ID 별 총 대여 횟수로 (컬럼명 : RECORDS)
# 월 오름차순, 자동차 ID 내림차순 - 조건(3)

SELECT MONTH, CAR_ID, RECORDS
FROM (SELECT MONTH(START_DATE) as MONTH
            , CAR_ID
            , count(CAR_ID) as RECORDS
            , SUM(count(CAR_ID)) OVER(PARTITION BY CAR_ID) AS SUMRECORDS
        FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY 
        WHERE start_date between '2022-08-01 00:00:00' AND '2022-10-31 23:59:59'
        GROUP BY CAR_ID, MONTH(START_DATE)
     )  A
WHERE SUMRECORDS  >= 5 
ORDER BY MONTH ASC , CAR_ID DESC



> 위문제의 핵심은 역시 윈도우함수, PARTITION
>  월(MONTH)별 그리고 자동차ID(CAR_ID)별로 자동차를 몇번 대여 했는지는 해당 컬럼을 GROUP BY 한후 COUNT(CAR_ID)를 이용해 구할 수 있다. 조건 (1)
>  하지만 조건(2)를 만족하기 위해서는 "총 대여수"를 알아야 했기 때문에 윈도우함수를 이용하여 CAR_ID를 파티션으로 나눈 뒤 SUMRECORDS 라는 일종의 필터를 만들었습니다. 
>  SUMRECORDS가 5 이상인 값들만 뽑은 뒤 조건에 맞는 컬럼들만 제출하면 정답입니다.
 
  
* PARTITION BY 과 GROUP BY의 차이점은 디테일에 있다.
* GROUP BY가 뭉탱이로 뭉치는(?) 느낌이라면..
* PARTITION BY절의 경우 기존의 행에서 값을 세세하게 집계,확인하고 싶을때 사용하면된다. 무조건 기억할것..!

