# 2022년 3월의 오프라인/온라인 상품 판매 데이터의 판매 날짜, 상품ID, 유저ID, 판매량을 출력
# OFFLINE_SALE 테이블의 판매 데이터의 USER_ID 값은 NULL 로 표시
# 판매일 상품ID 유저ID ASC

SELECT DATE_FORMAT(sales_date,'%Y-%m-%d') as sales_date
     ,product_id
     ,user_id
     ,sales_amount
 FROM ONLINE_SALE
WHERE MONTH(sales_date) = 3 

union all

SELECT DATE_FORMAT(sales_date,'%Y-%m-%d') as sales_date
    , product_id
    , null AS user_id # OFFLINE_SALE 테이블의 판매 데이터의 USER_ID 값은 NULL 로 표시
    , sales_amount
FROM OFFLINE_SALE 
WHERE MONTH(sales_date) = 3 
ORDER BY SALES_DATE ASC, PRODUCT_ID ASC, USER_ID ASC


# 풀이과정
# 두 테이블에서 WHERE MONTH(sales_date) = 3 조건을 달아 **3월에 해당하는 데이터들**만 뽑은뒤  union all 함수를 이용해 행을 붙이면 되지만 `OFFINE_SALE` 테이블에는 user_id 컬럼이 없었다. 컬럼의 개수가 다르기 때문에 합칠수 없고, `OFFLINE_SALE` 테이블의 판매 데이터의 USER_ID 값을 NULL 로 표시해야한다.
# 따로 조건을 걸 필요 없이 null 값을 갖는 컬럼을 만들 수 있다는걸 배웠다! 그냥 SELECT 절에 null 이라 적으면 모든 값이 null 인 column이 만들어진다.
