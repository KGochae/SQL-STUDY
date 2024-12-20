
# 계절별 미세먼지 농도의 평균값과 중앙값을 구해서 한테이블로 만들어야 하는 문제
# mysql 에서 중앙값을 구하려면..?  
# 내장함수가 없기 때문에 직접 행을 count하여 구해야한다.


# 우선 측정 날짜에 따라 "계절"을 라벨링 해준 테이블
with cte AS (
SELECT pm10
      , CASE WHEN MONTH(measured_at) BETWEEN 3 AND 5 THEN 'spring'
            WHEN MONTH(measured_at) BETWEEN 6 AND 8 THEN 'summer'
            WHEN MONTH(measured_at) BETWEEN 9 AND 11 THEN 'autumn'
            ELSE 'winter' END AS season
from measurements),

# 계절별 미세먼지 평균 농도
average as (
SELECT season
      , ROUND(AVG(pm10),2) AS pm10_average
FROM cte
GROUP BY season
)


  
# 중앙값 측정을위한 계절별 행수(total_rows)와 계절별로 미세먼지 농도를 차례대로 정렬한 (row_num) 
RankedData AS (
    SELECT
        season,
        pm10,
        ROW_NUMBER() OVER (PARTITION BY season ORDER BY pm10) AS row_num,
        COUNT(*) OVER (PARTITION BY season) AS total_rows
    FROM cte
),

# 홀수인경우 그대로 가운데에 있는 행을 가져오면됨, 짝수인 경우 두값의 평균을 구해야한다.)
# 가령, total_rows 가 3개라면 (3+1)/2  row_num 값이 2 인 행을 가져오게되고
# total_rows 가 4개라면 (4+1)/2 (버림하여 FLOOR) 4번째 행과 (4+2)/2 3번째 행을 가져와서 AVG() 평균을 구하면 된다
median as (
SELECT
    season
    ,AVG(pm10) AS pm10_median
FROM RankedData
WHERE 
    row_num IN (floor((total_rows + 1) / 2), floor((total_rows + 2) / 2))
GROUP BY season),


# 최종적으로 AVERAGE 와 MEDIAN 테이블을 결합해서 제출
SELECT A.season
    , pm10_median
    , pm10_average
FROM average A
JOIN median M ON A.season = M.season
