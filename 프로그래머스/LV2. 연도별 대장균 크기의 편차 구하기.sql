

WITH A as(
        SELECT ID
            , YEAR(DIFFERENTIATION_DATE) AS YEAR
            , SIZE_OF_COLONY
            , MAX(SIZE_OF_COLONY) OVER (PARTITION BY YEAR(DIFFERENTIATION_DATE)) AS MAX_COLONY 
        FROM ECOLI_DATA )
        

  
  SELECT YEAR
    , MAX_COLONY - SIZE_OF_COLONY AS YEAR_DEV
    , ID
FROM A
ORDER BY YEAR,YEAR_DEV

> 연도별 대장균 크기의 편차(YEAR_DEV)를 한 테이블안에서 구하기 위해 윈도우 함수를 이용했는데요.🤔 MAX(SIZE_OF_COLONY) OVER (PARTITION BY YEAR(DIFFERENTIATION_DATE)) AS MAX_COLONY 이부분에 해당하는 쿼리입니다.
> MAX_COLONY 와 SIZE_OF_COLONY 의 값을 빼줘야 하는데 윈도우 함수를 이용하면새로운 테이블이 아닌 기존 테이블 내에서 연도별 MAX_COLONY 컬럼 값을 구할 수 있습니다.

