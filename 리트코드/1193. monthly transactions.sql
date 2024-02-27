



SELECT  date_format(trans_date,'%Y-%m') as month
        , country
        , count(id) as trans_count
        , SUM(CASE WHEN state = 'approved' then 1 else 0 END) as approved_count
        , SUM(amount) as trans_total_amount
        , SUM(CASE WHEN state = 'approved' then amount else 0 END) as approved_total_amount
FROM Transactions
GROUP BY month, country


> 필요 skill
> date_format 을 이용하여 원하는 날짜의 형태로 변형 
> month 와 country 그리고 state 가 'apporved' 여부에 따라 집계해야하는 컬럼이 있음 
> 먼저 approved_count 의 경우 state 값이 'approved'인 경우 1로 만든뒤 합쳐주면 approved의 개수가 되고
> approved_total_amount 마찬가지로 approved에 해당하는 amount만 가져와서 SUM 하면 된다.
