# yammer 데이터 A/B TEST 쿼리 연습


WITH test_contrl_tbl AS (
      SELECT experiment_group
            , COUNT(user_id)        as users
            , SUM(cnt_message)      as total
            , AVG(cnt_message)      as avg
            , STDDEV(cnt_message)   as std
            , VARIANCE(cnt_message) as var
            -- 실험군과 대조군 값을 한행으로      
            , MAX(CASE WHEN experiment_group = 'control_group' THEN COUNT(user_id) ELSE NULL END) OVER ()         AS control_users
            , MAX(CASE WHEN experiment_group = 'control_group' THEN SUM(cnt_message) ELSE NULL END) OVER ()       AS control_total
            , MAX(CASE WHEN experiment_group = 'control_group' THEN AVG(cnt_message) ELSE NULL END) OVER ()       AS control_avg
            , MAX(CASE WHEN experiment_group = 'control_group' THEN STDDEV(cnt_message) ELSE NULL END) OVER ()    AS control_stg
            , MAX(CASE WHEN experiment_group = 'control_group' THEN VARIANCE(cnt_message) ELSE NULL END) OVER ()  AS control_var
      
      FROM (SELECT u.user_id
                , ex.experiment
                , ex.experiment_group
                , count(e.user_id) as cnt_message
            FROM tutorial.yammer_experiments ex
              JOIN tutorial.yammer_users u ON ex.user_id = u.user_id
                    AND u.activated_at < '2014-06-01' -- 가입날짜기준
              LEFT JOIN tutorial.yammer_events e ON ex.user_id = e.user_id 
                    AND e.occurred_at BETWEEN ex.occurred_at AND '2014-06-30 23:59:59' -- 실험기간
                    AND e.event_name = 'send_message' -- 반응기준
            GROUP BY u.user_id, ex.experiment, ex.experiment_group ) as  msg_cnt_BY_USER
      GROUP BY experiment_group )
      

    
-- T-TEST AND P-VALUE
SELECT a.*
      , (a.avg - a.control_avg) / SQRT((a.var/a.users) + (a.control_var/a.control_users)) AS t_stat
      , (1 - COALESCE(nd.value,1))*2 AS p_value -- 양측검정
FROM test_contrl_tbl a
LEFT JOIN  benn.normal_distribution nd -- z값 테이블
    ON nd.score = ABS(ROUND((a.avg - a.control_avg)/SQRT((a.var/a.users) + (a.control_var/a.control_users)),3))
