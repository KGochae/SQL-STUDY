


SELECT product_id
    , product_name
    , amount*price as total_sales
FROM (SELECT a.product_id
          , b.product_name
          , sum(a.amount) as amount
          , b.price
      FROM FOOD_ORDER a
      LEFT JOIN FOOD_PRODUCT b ON a.product_id = b.product_id
      WHERE MONTH(a.PRODUCE_DATE) = 5
      GROUP BY a.product_id) A
ORDER BY total_sales desc , product_id 


  
# 시나리오
# WHERE ?`FOOD_ORDER` 테이블 에서 MONTH() 함수를 이용해 `생산일자`가 5월인 식품들을 걸러줍니다. 
# 결국 구해야하는 것은 `식품 ID` 별 총매출 이기 때문에, 주문된 `식품 ID`를 GROUP BY 해준 뒤 `주문량`을 집계처리 해줘서 `식품 ID` 별 `총 주문량`(AMOUNT)을 구해줍니다. ☞ TABLE `A`
# 조건에 맞게 구해진 TABLE `A`의 `식품이름`,`총매출`을 구하기 위해 `FOOD_PRODUCT`와 JOIN 해줍니다. 
# 총매출 =`가격`*`총 주문량` 
