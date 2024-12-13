# developer_id 별로 합계매출이 가장 높은 platform_id 행만 가져와야 함
# sales 합계를 기준으로 중복을 허용한다고 했으니 윈도우 함수 DENSE_RANK를 이용하여 devleoper_id 별 sales_rnk를 구해주었고
# sales_rnk = 1 에 해당하는 값을 가져온 뒤, 문제에 필요한 name 정보들을 결합하였습니다.


WITH A as (
      SELECT developer_id 
          , platform_id
          , SUM(sales_na+sales_eu+sales_jp+sales_other) sales
          , DENSE_RANK() OVER (PARTITION BY developer_id order by SUM(sales_na+sales_eu+sales_jp+sales_other) DESC) sales_rnk
      FROM games
      GROUP BY developer_id, platform_id
)

SELECT C.name as developer
      , B.name AS platform
      , sales
FROM A
JOIN platforms B on A.platform_id = B.platform_id
JOIN companies C on A.developer_id = C.company_id
where sales_rnk = 1 
