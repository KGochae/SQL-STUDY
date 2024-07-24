# WINDOW 함수 이용
# 여러 방법이 있겠지만, 저는 ROW_NUMBER 를 이용해서 FISH_TYPE 별 가장 큰 LENGTH 에 1을 부여하고 1에 해당하는 물고기들만 필터링 하는 방법을 이용했습니다.

SELECT A.ID
    , B.FISH_NAME
    , A.LENGTH
FROM (SELECT *
            , ROW_NUMBER() OVER(PARTITION BY FISH_TYPE ORDER BY LENGTH DESC) N
      FROM FISH_INFO 
        ) A
JOIN FISH_NAME_INFO B ON A.FISH_TYPE = B.FISH_TYPE
WHERE N = 1
ORDER BY A.ID ASC
