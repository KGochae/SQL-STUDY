# Write your MySQL query statement below

# 가장 많이 평가를 내린 유저의 이름 (이름 철자순) 과 2020년 2월 기준으로 가장 평균 평점이 높은 영화를 union 하여 한 컬럼에 결합하는 쿼리


(SELECT name as results
FROM movierating a
join users b using (user_id)
group by name 
order by count(name) desc , results asc
limit 1)

union all

(SELECT title as results
FROM movierating a
JOIN Movies c USING (movie_id)
WHERE YEAR(created_at) = 2020 and MONTH(created_at) = 2 
GROUP BY title
ORDER BY avg(rating)  desc, results asc 
limit 1)
