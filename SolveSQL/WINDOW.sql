# 정해진 기간에서 1시간 범위의 이동평균선을 구하는 문제 - CTE 테이블에 해당
# ROWS  행 개수 자체로 집계 
# RANGE 의 경우 날짜나 시간 단위로 집계할 수 있음 ( ex. 현재행 부터 한시간 이전 시간의 AVG 집계 = RANGE BETWEEN INTERVAL 1 HOUR PRECEDING AND CURRENT ROW)
# 다만 meaured_at 을 이동평균선의 끝 지점을 기준으로 (end_at) 표현해야 하는데, LAG를 이용하여 해결 (문제가 좀 불친절해서  아직까지 이해가 잘 되지 않는부분..) 

# 첫번째 제출 (뭔가 이상함)
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------
       
# 두번째 제출 (해결)
# 굳이 lag를 할 필요가 없었다. 우선 범위를 6 행으로 지정해주고 윈도우 함수에서 CURRENT ROW 의 경우 현재 행을 포함하여 계산하기 되는데,
# 이동평균선의 끝 지점을 기준으로 표현해야 하기 때문에 1 PRECEDING 을 입력해주면 된다. 이게 뭐냐!? 아래의 테이블로 직접 보면 이해하기 쉽다! 

# 예를 들어,  아래와 같은 테이블이 있다면
# 자연스럽게 데이터의 첫행인 2017-01-01 00:00:00 시점의 이동평균선 값들은 NULL 값이 생길 수 밖에 없음 (이전 값이 없고, 본인의 행을 포함하면 안되기 때문에)
# 그리고 measured_at 이 자연스럽게 end_at (이동평균선 범위의 끝지점)이 되는 것
        
measured_at          zone_quads  avg_zone_quads
2017-01-01 00:00:00     10          null
2017-01-01 00:10:00     30          10/1
2017-01-01 00:20:00     20         (10+30)/2
2017-01-01 00:30:00     40         (10+30+20)/3
2017-01-01 00:40:00     10         (10+30+20+50)/4
2017-01-01 00:50:00     10         (10+30+20+50+10)/5
2017-01-01 01:00:00     5          (10+30+20+50+10+5)/6


       
WITH CTE AS (
SELECT measured_at  AS end_at
       ,ROUND(AVG(zone_quads) OVER(ORDER BY measured_at ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING), 2) AS zone_quads
       ,ROUND(AVG(zone_smir) OVER(ORDER BY measured_at ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING), 2) AS zone_smir
       ,ROUND(AVG(zone_boussafou) OVER(ORDER BY measured_at ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING), 2) AS zone_boussafou

FROM power_consumptions
WHERE measured_at BETWEEN '2017-01-01 00:00:00' AND '2017-02-01 00:00:00')

SELECT *
from CTE
WHERE end_at > '2017-01-01 00:00:00'


