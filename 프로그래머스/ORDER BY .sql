# 역 과 역사이의 길이합, 평균길이를 구하는 문제
# 이 문제의 핵심은 마지막 order by 를 TOTAL_DISTANCE 내림차순으로 정렬해야하는데, 
# order by는 sql 구문에서 가장 마지막에 적용된다. 얼라이언스가 적용된 TOTAL_DISTANCE로 정렬하게 되면 문자열 형태로 정렬하게 되는 것
# CONCAT 하기 전, 숫자 형태의 값인 SUM(D_BETWEEN_DIST)로 ORDER BY 해주어야한다.

select ROUTE
    , CONCAT(ROUND(SUM(D_BETWEEN_DIST),1),'km') AS TOTAL_DISTANCE
    , CONCAT(ROUND(AVG(D_BETWEEN_DIST),2),'km') AS AVERAGE_DISTANCE
    
from subway_distance
GROUP BY ROUTE
ORDER BY SUM(D_BETWEEN_DIST) DESC
