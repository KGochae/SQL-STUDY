# 문제의 핵심
# 요일별로 평균농도를 집계 + 월요일부터 출력

# 시나리오
* '%Y-%M-%d' 형태의 데이터 포맷을 '%w' 로 바꾸게 되면 일요일(0)~토요일(7) 숫자로 표현됨
* 문제에서 요구하는 방식에 따라 이를 문자로 바꾸고, 월요일 부터 order by 해야함
* 하지만, 일요일이 0 값을 갖기 때문에, 일요일부터 출력이 되버린다.
* order by 에도 조건문이 가능하다는 사실을 알게 되었다! -> weekday = 0 을 7로 조건을 주면 되는..!


  
SELECT CASE WHEN weekday = 0 THEN '일요일' 
            WHEN weekday = 1 THEN '월요일' 
            WHEN weekday = 2 THEN '화요일' 
            WHEN weekday = 3 THEN '수요일' 
            WHEN weekday = 4 THEN '목요일' 
            WHEN weekday = 5 THEN '금요일' 
            WHEN weekday = 6 THEN '토요일' ELSE '' END as weekday
      , no2, o3, co, so2, pm10, pm2_5

FROM (SELECT DATE_FORMAT(measured_at,'%w') as weekday
      , ROUND(AVG(no2),4) no2
      , ROUND(AVG(o3),4) o3
      , ROUND(AVG(co),4) co
      , ROUND(AVG(so2),4) so2
      , ROUND(AVG(pm10),4) pm10
      , ROUND(AVG(pm2_5),4)  pm2_5  
FROM measurements
GROUP BY DATE_FORMAT(measured_at,'%w')) A
ORDER BY 
    CASE WHEN weekday = 0 THEN 7 ELSE weekday 
    END
