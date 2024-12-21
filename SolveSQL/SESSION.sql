# 유저의 로그 데이터의 세션을 정의하는 문제 입니다.
# 10분 (600초) 이상 아무런 행동이 없을 경우를 기준으로 세션id를 나눠야합니다.


# cte 테이블 - 특정 유저id를 가져오고 event 를 row_number 로 순서정렬 ( 같은시간에 일어나는 event가 있었기 때문에 순서를 명확히 하기 위해서)
with cte as (
  select user_pseudo_id
        , event_timestamp_kst
        , event_name
        , ga_session_id
        , ROW_NUMBER() over() as id
  from ga
  where user_pseudo_id = 'a8Xu9GO6TB'
  ORDER BY event_timestamp_kst
),


# diff 테이블 - 이전에 일어났던 event 시간과의 차이를 구한 값을 추가 
diff as (
SELECT *
     , TIMESTAMPDIFF(SECOND, last_event, event_timestamp_kst) as last_diff
FROM (select *
            , LAG(event_timestamp_kst) OVER(PARTITION BY user_pseudo_id order by ID ) as last_event        
      from cte) A
)

# A 서브쿼리 - 이전 로그와 600초 이상인 경우, 그리고 첫번째 로그는 이전 로그가 없기 때문에 NULL 값이됨 -> 이에 해당하는 경우 세션의 시작이라고 볼 수 있음
# 이후 id ( 이벤트가 발생한 순서 ) 정렬하고 user_pseudo_id 별로 session 을 누적합
SELECT user_pseudo_id
      , event_timestamp_kst
      , event_name
      , ga_session_id
      , SUM(session) OVER (PARTITION BY user_pseudo_id ORDER BY id) AS new_session_id -- 세션 번호 부여
FROM (SELECT  *
            , CASE WHEN last_diff is null 
              OR last_diff >= 600 THEN 1 ELSE 0 END session # 세션의 시작인 경우 1
      FROM diff) A


---------------------- 예시 테이블로 이해해보기 ------------------------------------------------------------------------------------------------
  
# 만약 A 테이블이 아래의 상태라면 
user_pseudo_id  last_diff  session
a8Xu9GO6TB        null       1      # 첫번째 세션의 시작
a8Xu9GO6TB        30         0
a8Xu9GO6TB        700        1      # 두번째 세션의 시작
a8Xu9GO6TB         3         0

  
# SUM() 윈도우 함수 (누적합)을 통해 다음 SESSION이 정의된다.
user_pseudo_id  last_diff  session
a8Xu9GO6TB        null       1
a8Xu9GO6TB        30         1   (1+0)
a8Xu9GO6TB        700        2   (1+1)
a8Xu9GO6TB         3         2   (2+0)

