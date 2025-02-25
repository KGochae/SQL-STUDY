# 세션이 종료되는 기준을 1시간동안 아무런 로그가 없는 경우로 바꾸고, 세션의 시작 시간과 종료시간을 구할떄

SELECT user_pseudo_id
      ,MIN(event_timestamp_kst) session_start 
      ,MAX(event_timestamp_kst) session_end
FROM (
SELECT step2.* 
      , CASE WHEN last_diff IS NULL THEN id 
              WHEN last_diff >= 3600 THEN id 
              ELSE LAG(id, 1) OVER (PARTITION BY user_pseudo_id ORDER BY id)END AS session 
FROM (
 SELECT user_pseudo_id
       ,event_timestamp_kst
       ,id
       ,TIMESTAMPDIFF(SECOND, last_event, event_timestamp_kst) last_diff 
       ,TIMESTAMPDIFF(SECOND, event_timestamp_kst, next_event) next_diff 
  FROM (
      SELECT user_pseudo_id
            ,event_name
            ,event_timestamp_kst
            ,LAG(event_timestamp_kst,1) OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp_kst) last_event
            ,LEAD(event_timestamp_kst,1) OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp_kst) next_event
            ,ROW_NUMBER() OVER () AS id
      FROM ga 
  ) step1
) step2
  WHERE last_diff IS NULL 
    OR next_diff IS NULL 
    OR last_diff >= 3600
    OR next_diff >= 3600
) step3
GROUP BY user_pseudo_id, session
ORDER BY session_start

