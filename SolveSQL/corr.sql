# mysql 에서 피어슨 상관계수를 구하기 위해서는 어떻게해야 할까요
# 아무래도 내장함수가 없기 때문에, 직접 식을 구현해야 합니다

SELECT species
    , (AVG(flipper_length_mm * body_mass_g) - AVG(flipper_length_mm) * AVG(body_mass_g)) /
            (SQRT(AVG(flipper_length_mm * flipper_length_mm) - POW(AVG(flipper_length_mm), 2)) * SQRT(AVG(body_mass_g * body_mass_g) - POW(AVG(body_mass_g), 2))) AS corr
FROM penguins
GROUP BY species

# 비교하고자 하는 각각의 변수를 x,y 라고 했을 떄, 상관계수 구하는 식을 요약하면
# x*y의 평균 - x,y각각의 평균을  (x의 표준편차 * y의 표준편차)를 나눈 값 입니다.

# POW함수는 제곱근을 나타낼 때 사용
# POW(X,2) = X^2 
