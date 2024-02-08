

# 핵심 포인트 윈도우 함수를 이용한 필터
#각 DepartmentId 별로 가장 높은 salary 값을 갖는 employee 를 구해야 하기 때문에, DESN_RANK 를 이용하여 순위를 매긴다음 가장 높은 순위의 데이터만 가져오는 방법을 사용했습니다.
# 즉, '부서별' PARTITION BY departmendId 로 '급여'가 높은 ORDER BY salary 순으로 순위를 매기는데요! 공동 1등인 경우 모두 1등으로 중복하여 나타내주는 거죠! RNK 컬럼은 일종의 FILTER 역할을 합니다. WEHRE RNK = 1

SELECT Department,Employee,Salary
FROM(SELECT D.name AS Department
        , E.name AS Employee
        , Salary    
        , DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary desc) as RNK
    FROM EMPLOYEE E
    JOIN DEPARTMENT D ON E.departmentId = D.id) a
WHERE RNK = 1
ORDER BY Salary
