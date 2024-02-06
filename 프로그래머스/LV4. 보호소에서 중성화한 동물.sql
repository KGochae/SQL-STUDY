
# 호소에서 중성화 수술을 거친 동물 정보를 알아보려 합니다. 
# 보호소에 들어올 당시에는 중성화 되지 않았지만,  (intact)
# 보호소를 나갈 당시에는 중성화된 동물의 (spayed, neutered)
# animal_id 순으로 정렬!


SELECT ANIMAL_ID
    ,I.ANIMAL_TYPE
    ,I.NAME
FROM ANIMAL_INS I
INNER JOIN ANIMAL_OUTS O USING (ANIMAL_ID)
WHERE SEX_UPON_INTAKE LIKE 'Intact%' 
AND (SEX_UPON_OUTCOME LIKE 'Neutered%' OR SEX_UPON_OUTCOME LIKE 'Spayed%')
ORDER BY ANIMAL_ID

> 테이블이 현재 2개 주어져있습니다.
> 보호소에 들어올 당시 (ANIMAL_INTAKE) 와 보호소에 나갈 당시 (ANIMAL_OUTS)
> 그리고 각 테이블의 핵심 컬럼인 `SEX_UPON_INTAKE, OUTCOME` 중성화 여부를 비교해야 하기 때문에 JOIN 해주어야합니다.
> 두 테이블의 연결이되는 컬럼은 ANIMAL_ID 이므로 UNSING 으로 JOIN 해주었습니다!
> LIKE 를 이용해 조건을 처리해주면 해결!
