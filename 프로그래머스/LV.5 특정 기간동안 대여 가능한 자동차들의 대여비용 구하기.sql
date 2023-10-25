# CAR_RENTAL_COMPANY_CAR 테이블과 CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블과 CAR_RENTAL_COMPANY_DISCOUNT_PLAN 테이블에서 
# 자동차 종류가 '세단' 또는 'SUV' 인 자동차 중 
# 2022년 11월 1일부터 2022년 11월 30일까지 대여 가능하고 
# 30일간의 대여 금액이 50만원 이상 200만원 미만인 자동차에 대해서 
# 자동차 ID, 자동차 종류, 대여 금액(컬럼명: FEE) 리스트를 출력하는 SQL문



SELECT distinct c.CAR_ID
        , c.CAR_TYPE
        , round(c.DAILY_FEE*30*(100-p.DISCOUNT_RATE)/100) FEE
FROM CAR_RENTAL_COMPANY_CAR c 


JOIN (select CAR_TYPE, DISCOUNT_RATE
        from CAR_RENTAL_COMPANY_DISCOUNT_PLAN
        where DURATION_TYPE = '30일 이상') p # DURATION_TYPE 정보를 가져오기위해 JOIN 을 해줘야한다. 

on c.CAR_TYPE = p.CAR_TYPE

WHERE c.CAR_ID not in (select CAR_ID
                       from CAR_RENTAL_COMPANY_RENTAL_HISTORY
                       where END_DATE > '2022-11-00'
                       and START_DATE < '2022-12-00')  # ① 대여 가능한 날짜

and c.CAR_TYPE in ('세단', 'SUV') # 조건② 자동차 종류 와 대여 금액
having FEE >= 500000
and FEE < 2000000
order by FEE desc, c.CAR_TYPE, c.CAR_ID desc



# 문제에서 제시된 큰 조건부터 정리해보기

# 조건① 대여가능한날짜 2022년 11월 1일 ~ 2022년 11월 30일 인 경우 이므로 , 이 기간에 들어가는 데이터들을 빼면된다. 이미 대여중인 차량이기 때문이다. 
  즉, 대여기간이 끝나는 날짜 END_DATE가 2022년 11월 이후 인 경우와 대여를 시작한 날짜START_DATE 가 2022년 12월 전인 경우 대여가 불가능하므로 ⓛ WHERE 절 not in 안의 서브쿼리를 이용해서 제외 했다. 그러면 대여가능한 CAR_ID만 남는다.

# 조건② 대여가능한 CAR_ID 를 갖고 해당하는 CAR_TYPE과 DISCOUNT_RATE의 정보가 필요하기 때문에CAR_RENTAL_COMPANY_DISCOUNT_PLAN 테이블을 JOIN 시킨다.
  '30일 이상' 의 정보만 필요하기 때문에 DRUATION_TYPE 이 30일 이상 인 경우만 조건을걸어서 JOIN 시켰다.

# 자동차 종류가 '세단' , 'SUV' 그리고 대여 금액이 50만원 이상 200만원 미만인 값들만 뽑아준뒤 할인을 적용한 대여금액(컬럼명:FEE)을 구하고 문제에서 제시된 ORDER BY 조건을 따라주면 된다.
