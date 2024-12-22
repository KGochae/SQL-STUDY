
# 연도별 새롭게 소장된 작품수 "FLOW"
# 그리고 누적 작품수 " STOCK" 를 구하는 문제 입니다.

# A 테이블 -  "소장된 날짜" 작품이 없는 경우 제외하고, 연도별로 집계하기 위해 YEAR 정보를 추출한 테이블 입니다.
# B 테이블 -  연도별로 그룹하여 "FLOW" 를 구해주고 , 누적합을 구하기위해 ROW_NUMBER 컬럼을 생성
# 연도별로 집계된 FLOW 를 윈도우함수 SUM()을 이용하여 누적합
  
SELECT year as "Acquisition year"
    , Flow as "New acquisitions this year (Flow)"
    , SUM(flow) OVER(ORDER BY num) as "Total collection size (Stock)"
FROM (SELECT year
            , COUNT(artwork_id) as flow
            , ROW_NUMBER() OVER(ORDER BY year) AS num
      FROM (SELECT artwork_id
                  , YEAR(acquisition_date) as year
            FROM artworks
            WHERE acquisition_date IS NOT NULL) A
      GROUP BY year) B
