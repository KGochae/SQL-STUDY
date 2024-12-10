# 2024 solvesql 챌린지 문제 입니다. (https://solvesql.com/problems/find-christmas-games/)
# name 컬럼 값의 특정 단어가 포함되는 값들만 가져오는 문제입니다.
# like 함수를 이용하여 앞뒤로 포함되는 문자들을 추출했습니다.

SELECT game_id  
  , name
  , year
FROM games 
WHERE name like '%Christmas%'or name like '%Santa%'
