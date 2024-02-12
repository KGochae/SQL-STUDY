> 2016년의 총 투자 가치 합계를 조회**하는 SQL문을 작성해주세요
> 한 명 이상의 다른 보험 계약자와 동일한 2015년 총 투자 가치 값을 가지며, 다른 보험 계약자와 같은 도시에 있지 않는 데이터 (lat, lon 값은 중복되지 않아야 합니다) 


SELECT round(sum(tiv_2016),2) as tiv_2016
FROM Insurance
WHERE tiv_2015 in (SELECT tiv_2015
                    FROM Insurance
                    GROUP BY tiv_2015
                    HAVING count(tiv_2015) > 1) #조건1 2015년 투자 값이 같은 계약자

AND pid in (SELECT pid
            FROM Insurance
            Group by lat, lon
            HAVING count(*) = 1) # 위도 경도가 다른, 같은 도시에 있지 않은 보험계약자
 
