> 

SELECT s.user_id
    , round(avg(if(c.action = 'confirmed',1,0)),2) as confirmation_rate
FROM signups s
left join confirmations c on s.user_id = c.user_id 
group by s.user_id
