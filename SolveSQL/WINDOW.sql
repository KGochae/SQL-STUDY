# 정해진 기간에서 1시간 범위의 이동평균선을 구하는 문제 - CTE 테이블에 해당
# ROWS  행 개수 자체로 집계 
# RANGE 의 경우 날짜나 시간 단위로 집계할 수 있음 ( ex. 현재행 부터 한시간 이전 시간의 AVG 집계 = RANGE BETWEEN INTERVAL 1 HOUR PRECEDING AND CURRENT ROW)
# 다만 meaured_at 을 이동평균선의 끝 지점을 기준으로 (end_at) 표현해야 하는데, LAG를 이용하여 해결 (문제가 좀 불친절해서  아직까지 이해가 잘 되지 않는부분..) 


WITH CTE AS (
SELECT measured_at 
       ,ROUND(AVG(zone_quads) OVER(ORDER BY measured_at ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2) AS zone_quads
       ,ROUND(AVG(zone_smir) OVER(ORDER BY measured_at ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2) AS zone_smir
       ,ROUND(AVG(zone_boussafou) OVER(ORDER BY measured_at ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2) AS zone_boussafou

FROM power_consumptions
WHERE measured_at BETWEEN '2017-01-01 00:00:00' AND '2017-02-01 00:00:00')

SELECT *
FROM(SELECT measured_at as end_at
    , LAG(zone_quads) OVER(ORDER BY measured_at) zone_quads
    , LAG(zone_smir) OVER(ORDER BY measured_at) zone_smir
    , LAG(zone_boussafou) OVER(ORDER BY measured_at) zone_boussafou
FROM CTE)A
WHERE end_at > '2017-01-01 00:00:00'
from CTE
