# adddress 컬럼에서 sido 정보와 sigungu 정보 컬럼을 만들고
# 행정구역 별로 카페의 개수 count 해야하는 문제입니다.

SELECT sido
    , sigungu
    , count(*) as cnt
FROM (SELECT address
            , SUBSTRING_INDEX(address, ' ', 1) as sido
            , SUBSTRING_INDEX(SUBSTRING_INDEX(address, ' ', 2), ' ',-1) AS sigungu
      FROM cafes) A
GROUP BY sido, sigungu
ORDER BY cnt DESC

# 특정 구분자를 기준으로 문자열을 분리할 수 있는 함수는 MYSQL 기준 SUBSTRING_INDEX( col, 구분자, 출력문자범위) 함수 입니다!
# 가령, '강원도특별자치도 강릉시 가작로 13' 이라고 한다면 첫번째, sido 컬럼의 경우 첫번째 구분자 '강원도특별자치도' 로 분리가 될것이구요
# sigungu 의 경우, 우선 '강원도특별자치도 강릉시' 까지의 문자열 까지 가져온후, 한번더 함수를 사용하여 뒤 문자열(-1)을 가져온 것을 볼 수 있습니다.
# '가작로 13' 도로명 주소는 필요없기 때문이죠.
