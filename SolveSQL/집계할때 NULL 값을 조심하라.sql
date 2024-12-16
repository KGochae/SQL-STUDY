# 문제를 간단히 설명해 보자면
# 2018년 10월 부터 11월 까지의 (대여+반납)수 에 비해
# 2019년 10월 부터 11월 까지의 (대여+반납)수 가 얼마나 증가했는지 구하는 문제입니다.

# 해당 쿼리에서 굉장히 해맸던 부분이 있었는데, 바로 "NULL"을 제대로 처리하지 못해서 생긴 이슈였습니다.   
# 문제의 station_id 는 '2288' 입니다.

# 위 id의 경우 2019년 rent 기록은 있지만 return 기록은 없었는데요.
# 만약 이상태에서 19년의 rent 와 return 을 그냥 합쳐버리면 2288의 19년도 대여/반납 건수는 NULL이 되어버립니다.
# 그렇기 때문에 COALECSE로 처리가 필요하다!!!!!!!

# 18년도 station 별 렌트 횟수
WITH rent_18 AS (
  SELECT rent_station_id      
        ,count(rent_station_id) as rent_cnt
  FROM rental_history
  WHERE rent_at BETWEEN '2018-10-01 00:00:00' AND '2018-11-01 00:00:00'
  GROUP BY rent_station_id ) ,

  # 18년도 station 별 반납 횟수
return_18 AS (  
  SELECT return_station_id
        ,count(rent_station_id) as return_cnt
  FROM rental_history
  WHERE return_at BETWEEN '2018-10-01 00:00:00' AND '2018-11-01 00:00:00'
  GROUP BY return_station_id ),

# 18년도 총 렌트,반납 횟수
bike_18 AS (
SELECT A.rent_station_id as station_id
      ,COALESCE(rent_cnt, 0) + COALESCE(return_cnt, 0) AS cnt_18           # 해당 문제의 핵심, 렌트 혹은 대여 한적 없더라도 0 으로 표시해야 함 둘중 하나가 NULL 인 경우 NULL로 잡아 먹히기 때문
FROM rent_18 A
LEFT JOIN return_18 B ON A.rent_station_id = B.return_station_id),

# 19년도 station별 렌트 횟수
rent_19 AS (
  SELECT rent_station_id      
        ,count(rent_station_id) as rent_cnt
  FROM rental_history
  WHERE rent_at BETWEEN '2019-10-01 00:00:00' AND '2019-11-01 00:00:00'
  GROUP BY rent_station_id ) ,

# 19년도 station 별 반납 횟수
return_19 AS (  
  SELECT return_station_id
        ,count(return_station_id) as return_cnt
  FROM rental_history
  WHERE return_at BETWEEN '2019-10-01 00:00:00' AND '2019-11-01 00:00:00'
  GROUP BY return_station_id ),

# 19년도 총 렌트,반납 횟수
bike_19 AS (
SELECT A.rent_station_id as station_id
      ,COALESCE(rent_cnt, 0) + COALESCE(return_cnt, 0) AS cnt_19
FROM rent_19 A
LEFT JOIN return_19 B ON A.rent_station_id = B.return_station_id)

SELECT A.station_id 
    ,S.name
    ,S.local
    ,ROUND(cnt_19*100/cnt_18,2) AS usage_pct
FROM bike_18 A
JOIN bike_19 B on A.station_id = B.station_id
JOIN station S ON A.station_id = S.station_id
WHERE (cnt_19*100/cnt_18) <= 50
