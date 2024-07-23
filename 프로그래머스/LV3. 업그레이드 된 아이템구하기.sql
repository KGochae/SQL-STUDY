-- 아이템의 희귀도가 'RARE'인 아이템들의 모든 다음 업그레이드 아이템의 아이템 ID(ITEM_ID), 아이템 명(ITEM_NAME), 아이템의 희귀도(RARITY)를 출력하는 SQL 문을 작성해 주세요.
-- 이때 결과는 아이템 ID를 기준으로 내림차순 정렬주세요.

SELECT A.ITEM_ID
    , B.ITEM_NAME
    , B.RARITY
FROM ITEM_TREE A
LEFT JOIN ITEM_INFO B ON A.ITEM_ID = B.ITEM_ID
WHERE PARENT_ITEM_ID IN(SELECT DISTINCT(ITEM_ID)
                        FROM ITEM_INFO
                        WHERE RARITY = 'RARE')
ORDER BY ITEM_ID DESC

-- 문제의 핵심은 WHERE IN 
-- PARENT_ITEM_ID 값에 해당하는 ID 값들이 결국 업그레이드 가능한 ITEM_ID 이므로 
-- 희귀도가 RARE 이면서 PARENT_ITEM_ID 인 경우만 가져오면 된다
