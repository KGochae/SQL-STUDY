# 3028 유저의 3명의 친구관계를 뽑아내는 쿼리
# 가령, 아래의 경우  3020, 2, 3 세명의 id 가 친구관계임 
user_a_id user_b_id
    3020        2
    3020        3
    2           3



  
SELECT 
    t1.user_a_id AS user_a_id,
    t1.user_b_id AS user_b_id,
    t2.user_b_id AS user_c_id
FROM 
    edges t1
JOIN 
    edges t2
    ON t1.user_b_id = t2.user_a_id
JOIN 
    edges t3
    ON t2.user_b_id = t3.user_b_id
WHERE 
    t3.user_a_id = t1.user_a_id
    AND 3820 IN (t1.user_a_id, t1.user_b_id, t2.user_b_id)
    AND t1.user_a_id < t1.user_b_id
    AND t1.user_b_id < t2.user_b_id
