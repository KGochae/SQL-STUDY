-- 더이상 업그레이드 할 수 없는 ITEM_ID, ITEM_NAME, RARITY 출력


--   join을 이용해서 푸는 방법
-- ITEM_TREE 테이블의 ITEM_ID 값이 NULL 인경우를 이용해 다음 업그레이드가 없다는것을 확인

SELECT A.ITEM_ID 
         , A.ITEM_NAME
         , A.RARITY
FROM ITEM_INFO A   
LEFT JOIN ITEM_TREE B ON A.ITEM_ID = B.PARENT_ITEM_ID
WHERE B.PARENT_ITEM_ID IS NULL
ORDER BY ITEM_ID DESC

-- NOT IN 

SELECT item_id, item_name, rarity
FROM ITEM_INFO
WHERE item_id NOT IN (
    SELECT DISTINCT(parent_item_id)
    FROM ITEM_TREE
    WHERE parent_item_id IS NOT NULL
)
ORDER BY 1 desc
