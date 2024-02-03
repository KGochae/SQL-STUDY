SELECT CART_ID
FROM (SELECT CART_ID
        ,CASE WHEN NAME LIKE 'Yogurt' THEN 1 ELSE 0 END AS yogurt_cnt
        ,CASE WHEN NAME LIKE 'Milk' THEN 1 ELSE 0 END AS milk_cnt    
    FROM CART_PRODUCTS
    WHERE NAME IN('Yogurt','Milk')
      ) A
GROUP BY CART_ID
HAVING sum(yogurt_cnt) > 0 AND sum(milk_cnt) > 0
ORDER BY CART_ID  


> ① 요거트와 우유를 동시에 산 장바구니만 구해야합니다.
> 필터를 만들어서 해결하는 방법을 이용했습니다.
> yogurt_cnt 와 milk_cnt을 추가해주고 CART_ID 로 groupby 했을 때, 요거트와 우유를 모두 하나 이상 담은 장바구니라면 아래의 식을 만족할 것입니다. sum(yogurt_cnt) > 0 AND sum(milk_cnt) > 0
