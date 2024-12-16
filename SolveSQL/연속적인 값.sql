# 5년 연속으로 fiction 장르의 상을 받은 author를 추려내는 문제
# 단순히 5번 상을 받은것이 아닌 "연속"이라는 조건 이 있기 때문에 어려웠다.
# 이전 year 과 gap을(diff 컬럼) 구해서 결국 풀었는데
# 아직 좀 찝찝한 부분이 있음.


WITH CTE AS (
  SELECT author
        , year
        , LAG(year) OVER(PARTITION BY author ORDER BY year ) as LAST_YEAR
        , CASE WHEN (year - LAG(year) OVER(PARTITION BY author ORDER BY year )) = 1 THEN 1 ELSE 0 END as DIFF 
  FROM books
  WHERE genre ='Fiction'
  GROUP BY author, year)

> CTE 테이블의 결과를 샘플로 가져오면 다음과 같습니다.
> year 과 LAST_YEAR 의 차이가 1년 이라면 즉, 연속적이라면 DIFF 값에는 1이 남을 것입니다.
> 아래 Harper LEE 작가의 경우 2013,2014,2015 총 3연속 상을 받았다고 볼 수 있습니다.
> 그렇다면 author 별로 Group by 하여 sum(diff)를 구해주면 되겠죠 
> 하지만, Last_Year 과 year이 한행으로 되어있기 때문에 + 1 를 해주어야 합니다. 
> 즉, sum(diff) 가 2라면 3연속 상을 받은 것이고 , 4라면 5연속 상을 받은 것이라고 볼 수 있습니다.  

  author       year     LAST_YEAR  DIFF  
Harper LEE   2013                  0
Harper LEE   2014     2013         1
Harper LEE   2015     2014         1
Harper LEE   2016     2015         0
Harper LEE   2019     2016         0
    

SELECT author
      , max(year) as year
      , sum(diff) + 1 as depth
FROM CTE
GROUP BY author 
HAVING sum(diff) >= 4  


> 하지만 문제를 풀면서 좀 찝찝했던 case 가 있는데 
> 아래와 같이 단순히 diff 를 집계하게 되면 마찬가지로
  sum(diff) 의 값은 4가 나올 것입니다. 5년 연속적으로 상을 받은것은 아닌데 말이죠..
> 운좋게 쿼리를 통과했지만, 아직 이부분에 대해서 해결은 못했기 때문에 더 생각해봐야겠습니다.

  author       year     LAST_YEAR  DIFF  
Harper LEE   2013                  0
Harper LEE   2014     2013         1
Harper LEE   2015     2014         1
Harper LEE   2016     2015         0
Harper LEE   2019     2016         0
Harper LEE   2020     2019         1
Harper LEE   2021     2020         1
