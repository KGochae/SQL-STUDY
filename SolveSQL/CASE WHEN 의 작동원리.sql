# 2021년 개봉 영화 목록 가져오기
# OTT 플랫폼들이 컬럼값으로 존재하며 (0,1) 형태로 남겨지고 있음  (1 인 경우, 해당 플랫폼에서 영화를 볼 수 있는 것)
# 다만, 해당영화를 볼 수 있는 platfrom 이 여러개인 경우, 아래의 우선 순위로 하나의 플랫폼만 나오도록 쿼리를 짜야한다. 
# netflix > prime_video > disney_plus > hulu 

with movie_12 as (
  SELECT title
            , year
            , genres
            , directors
            , netflix
            , prime_video
            , disney_plus
            , hulu
        FROM movies
        WHERE year = 2021) 

# CASE WHEN 의 작동원리를 이용해야한다.
# 위에서부터 차례로 평가하므로, netflix가 1이면 바로 선택되고 다른 조건은 평가되지 않는다.
# 다른 플랫폼이 1인 경우, netflix가 아니라면 그다음 우선순위인 prime_video가 선택된다.
# 이런 방식으로 우선순위가 높은 플랫폼명을 CASE WHEN 에 입력해주면, 자동적으로 값이 반환된다.

SELECT title
      , year
      , genres
      , directors                                                
      , CASE  # netflix > prime_video > disney_plus > hulu 
           WHEN netflix = 1 THEN 'netflix'
           WHEN prime_video = 1 THEN 'prime_video'
           WHEN disney_plus = 1 THEN 'disney_plus'
           WHEN hulu = 1 THEN 'hulu'
       END AS platform
FROM movie_12
ORDER BY title
