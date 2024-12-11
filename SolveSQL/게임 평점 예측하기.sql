# 문제 핵심 요약
# 각 게임의 누락된 평론가 수, 평점 -> 같은 장르의 평균 값으로 채워넣기
# 각 게임의 누락된 사용자 수, 평점 -> 같은 장르의 평균 값으로 채워넣기
# 평점은 반올림 , 사용자/평론가 수는 올림

# 최종적으로 2015년 이후 null 값이었던 데이터만 출력

with AVG_CTE as (
SELECT genre_id
    , round(avg(critic_score),3) avg_c_s
    , CEILING(avg(critic_count)) avg_c_c
    , round(avg(user_score),3)   avg_u_s
    , CEILING(avg(user_count))   avg_u_c
FROM games
GROUP BY genre_id )

# 시나리오
* 우선 각 게임장르별 평균 값들을 구한 테이블을 따로 구해주고
* 기존의 table과 게임 장르 별로 JOIN 해주게 되면 장르별 평균 값들이 같은 테이블에 나열 되어있을 것
* CASE 구문을 이용하여 NULL 값인 경우 평균 값들로 대체하는 쿼리 작성  

SELECT game_id
      , name
      , CASE WHEN G.critic_score is null THEN C.avg_c_s ELSE G.critic_score END AS critic_score
      , CASE WHEN G.critic_count is null THEN C.avg_c_c ELSE G.critic_count END AS critic_count
      , CASE WHEN G.user_score is null THEN C.avg_u_s ELSE G.user_score END AS user_score
      , CASE WHEN G.user_count is null THEN C.avg_u_c ELSE G.user_count END AS user_count
FROM games G
JOIN AVG_CTE C ON G.genre_id = C.genre_id
WHERE year >= 2015 AND (critic_score is null or user_score is null)


