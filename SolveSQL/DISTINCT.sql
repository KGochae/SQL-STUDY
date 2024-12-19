# 2012년 이후
# 2개이상의 서로 다른 메이져 플랫폼에 출시한 게임을 출력하는 문제 입니다.
# (CTE 테이블을 요약해보면) game 테이블에 platform name 정보들을 추가해주고,
# case when 를 이용하여 3대 메이져 플랫폼 (소니,닌텐도,마이크로소프트) 를 라벨링 해주었습니다. 

WITH CTE AS (
SELECT game_name
      , platform_name
      ,  CASE WHEN platform_name in ('PS3', 'PS4', 'PSP', 'PSV') THEN 'Sony'
              WHEN platform_name in ('Wii', 'WiiU', 'DS', '3DS') THEN 'Nintendo'
              WHEN platform_name in ('X360', 'XONE') THEN 'Microsoft'
              ELSE platform_name END AS major_platform          
FROM (SELECT G.year
            , G.name AS game_name
            , G.platform_id
            , P.name AS platform_name
        FROM games G
        JOIN platforms P ON G.platform_id = P.platform_id
        WHERE year >= 2012  AND P.name IN ('PS3', 'PS4', 'PSP', 'PSV',
                                          'Wii', 'WiiU', 'DS', '3DS',
                                          'X360', 'XONE')       
        ) A
)

# 이후 게임명을 그룹지어 중복을 제거한 major_platform 수가 2개 이상인 경우만 집계했습니다.  
SELECT game_name AS name
FROM CTE
GROUP BY game_name 
HAVING COUNT(DISTINCT major_platform) > 1
