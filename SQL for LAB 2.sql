use film;
select r.rental_id, convert(r.rental_date, date) as r_date,
date_format(convert(r.rental_date,date), '%m') as r_month,
date_format(convert(r.rental_date,date), '%Y') as r_year, r.customer_id, i.inventory_id, i.store_id,
f.film_id, f.language_id, f.rental_duration, f.rental_rate, f.length, f.rating, f.special_features, c.category_id from sakila.rental as r
join sakila.inventory as i
on r.inventory_id=i.inventory_id
join sakila.film as f
on i.film_id=f.film_id
join sakila.film_category as c
on f.film_id=c.film_id;


with cte_rental as (
select
i.film_id, count(r.rental_id) as n_rentals,
count(distinct r.customer_id) as n_different_customer,
date_format(convert(r.rental_date,date), '%m') as r_month,
date_format(convert(r.rental_date,date), '%Y') as r_year
from sakila.rental as r
right join sakila.inventory as i
on r.inventory_id=i.inventory_id
group by film_id, r_year, r_month
)
select cte.film_id, cte.n_rentals, cte.n_different_customer, cte.r_month, cte.r_year, 
f.language_id, f.rental_duration, f.rental_rate, f.length, f.rating, f.special_features, c.category_id,
case 
when cte.r_month="02" then 1
else 0
end as rented_last_month
from cte_rental as cte
join sakila.film as f
on cte.film_id=f.film_id
join sakila.film_category as c
on f.film_id=c.film_id;


#2. approach
select date_format(convert(r.rental_date,date), '%m') as month_rent,
date_format(convert(r.rental_date,date), '%Y') as r_year, i.store_id,
f.film_id, f.rental_duration, f.rental_rate, f.length, f.rating, f.special_features, c.category_id,
case 
when month_rent=02 then 1
else 0
end as rented_last_month
from sakila.rental as r
right join sakila.inventory as i
on r.inventory_id=i.inventory_id
right join sakila.film as f
on i.film_id=f.film_id
join sakila.film_category as c
on f.film_id=c.film_id;


select
i.film_id, i.store_id, count(r.rental_id) as n_rentals,
count(distinct r.customer_id) as n_different_customer,
date_format(convert(r.rental_date,date), '%m') as r_month,
date_format(convert(r.rental_date,date), '%Y') as r_year
from sakila.rental as r
join sakila.inventory as i
on r.inventory_id=i.inventory_id
group by film_id, r_year, r_month, i.store_id;

#Create a query to get the list of films and a boolean indicating if it was rented last month. This would be our target variable.
