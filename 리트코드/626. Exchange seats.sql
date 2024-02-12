
> 연속된 두 학생의 좌석 ID를 교환하는 쿼리를 작성하는 문제입니다! (학생수가 홀수인 경우, 마지막 학생은 바뀌지 않음)
> mod() 함수를 이용하여 조건에 맞게 id 값을 변형 해주어야 해야한다.


SELECT CASE WHEN mod(id,2) = 1 AND id = (SELECT max(id) FROM Seat) THEN id #CASE 1
            WHEN mod(id,2) = 0 THEN id - 1 #CASE 2
            ELSE id + 1 #CASE 3
            END AS id , student
FROM Seat
ORDER BY id
