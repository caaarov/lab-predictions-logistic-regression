with cte_rental as (
select
i.film_id,
date_format(convert(r.rental_date,date), '%m') as r_month,
date_format(convert(r.rental_date,date), '%Y') as r_year
from sakila.rental as r
right join sakila.inventory as i
on r.inventory_id=i.inventory_id
)
select f.film_id,cte.r_month, cte.r_year, f.rental_duration, f.rental_rate, f.length, f.rating, f.special_features, c.category_id,
case
when f.film_id in (select film_id from rental as r
join inventory as i
using(inventory_id)
join film as f
using(film_id)
where date_format(convert(r.rental_date,date), '%m') =2) then 1
else 0
end as rented_last_month
from cte_rental as cte
join sakila.film as f
on cte.film_id=f.film_id
join sakila.film_category as c
on f.film_id=c.film_id
;