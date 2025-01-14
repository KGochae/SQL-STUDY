# WINDOWING 절을 사용하여 윈도우 함수에 포함시킬 (범위)를 지정할 수 있는데
# "rows" 현재 위치에서 물리적인 범위 (단순히 행의 순서)
# "range" 현재 row 값에서 논리적인 범위 (like 날짜 범위) 이며
# BETWEEN (시작) AND (끝) : 윈도우의 시작,끝 위치를 지정함

# ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  --> 여기서 CURRENT ROW (현재행)이 끝 위치가 되고 , 6번 이전의 행이 시작 위치가된다. 
  --> 즉 아래의 경우 dt 순으로, 현재의 컬럼부터 6 이전의 행값까지 가져온다.  = (rows between 6 preceding and current row)
  --> 만약, 6 이전의 행 값이 없다면 있는 값까지만 집계가 됨.  


# 매출의 흐름을 보기 위한 7일 이동평균선  
with seven_days as (
SELECT dt
  	, count(*) as purchas_cnt
    , SUM(purchase_amount) AS total_amount
  	, AVG(SUM(purchase_amount)) OVER (ORDER BY dt ROWS BETWEEN  6 PRECEDING AND CURRENT ROW) AS seven_day_avg    
FROM purchase_log
GROUP BY dt)


# 날짜별 매출과, 월별 누적합을 한테이블로 보기위해 윈도우함수 이용했다.
# 특정 범위가 아닌 UNBOUNDED 로 설정되어있기 때문에, 현재행부터 이전의 행을 다 더해짐 (누적합)
SELECT dt	
    , date_format(dt,'%Y-%m') as month
    , SUM(purchase_amount) as total_amount
    , SUM(SUM(purchase_amount)) OVER (PARTITION BY date_format(dt,'%Y-%m') ROWS BETWEEN unbounded preceding AND CURRENT ROW) as cum
FROM purchase_log
GROUP BY dt



# 가독성을 위해 우선 with 절로 나누어서 집계하는 것도 좋다.
# 또한 BETWEEN 절은 생략이 가능하다.
with daily_purchas as (
  SELECT dt
      , SUM(purchase_amount) AS total_amount
  FROM purchase_log
  GROUP BY dt
 )
 
 select dt
		, date_format(dt,'%Y-%m') month
		, total_amount
		, SUM(total_amount) OVER (PARTITION BY year,month ROWS unbounded preceding) AS cum
 from daily_purchas



