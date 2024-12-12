
# 3년간 들어온 소장품을 집계하는 쿼리를 만들어야합니다.
# 최종적으로 2014년에 들어온 소장품의 개수, 2015년, 2016년 컬럼 순으로 집계되어야 하며
# 해당 문제의 들어온 소장품이 없더라도 누락시키지 말고 포함해야 한다는 점 입니다.

SELECT  classification
    , COALESCE(SUM(CASE WHEN YEAR(acquisition_date) = 2014 THEN 1 ELSE 0 END), 0) AS "2014"
    , COALESCE(SUM(CASE WHEN YEAR(acquisition_date) = 2015 THEN 1 ELSE 0 END), 0) AS "2015"
    , COALESCE(SUM(CASE WHEN YEAR(acquisition_date) = 2016 THEN 1 ELSE 0 END), 0) AS "2016"
FROM artworks
GROUP BY classification
ORDER BY classification

# COALESCE(COL, VALUE) 의 경우 원하는 COL이 NULL 값을 갖는 경우 특정 값(VALUE)로 대체하는 함수 입니다.

# classification 대로 GROUP BY 하고
# 2014,2015,2016년 을 컬럼으로 세워야 하기 때문에 CASE WHEN 을 이용하여 각 연도에 해당하는 소장품들을 1로 표시 해준 뒤
# SUM() 하게되면 자연스럽게 0에 해당하는 값들은 없어지고 집계가 될 것 입니다.
# 하지만 들어온 소장품이 없더라도 누락시키지 말고 포함 ( = 0으로 표시) 해야하기 때문에 
# COALESCE() 를 이용하는 것이 이 문제의 핵심 KEY 라고 생각했습니다.
