-- Get the number of responses to each question by user
select question, count(distinct user_id) as 'Responses'
 from survey
 group by question;
 
 -- Understand the data sets we have to analyze; repeat below with each data set
select *
from quiz
limit 5;

select *
from home_try_on
limit 5;

select *
from purchase
limit 5;

-- Compare conversion from quiz to home try on
--- First get number of quiz takers
Select count(distinct(user_id)) as 'Quiz takers'
from quiz;

--- Get number of quiz users in the home try on set
Select count(distinct(q.user_id)) as 'Home try on users'
from quiz as q
join home_try_on as h
  on q.user_id = h.user_id;

--- Get number of quiz users that did home try ons in the purcase set
Select count(distinct(q.user_id)) as 'End purchasers'
from quiz as q
join home_try_on as h
  on q.user_id = h.user_id
join purchase as p
	on q.user_id = p.user_id;



-- create the custom table to show whether or not home try on happend (1/0), number of pairs for A/B test (3,5, "N/A" if no try on, and if a purchase was made (1/0)); then show the first 10 rows to check
with combined_table as(
  select 
		substr(distinct(q.user_id),1,8) as user_id,
    h.user_id IS NOT NULL as is_home_try_on,
    Case
      when h.number_of_pairs IS NOT NULL 
      then substr(h.number_of_pairs,1,1) 
      else 'N/A'
      end as number_of_pairs,
    p.user_id IS NOT NULL as is_purchase
  from quiz as q
  left join home_try_on as h
     on q.user_id = h.user_id
  left join purchase as p
    on q.user_id = p.user_id)
select *
from combined_table
limit 10;

-- Code to add to get number of users with each glasses count
select count(user_id), number_of_pairs
from combined_table
group by number_of_pairs;

-- Code to add to get number of users with each glasses count that made a purchase
select sum(is_purchase)
from combined_table
where number_of_pairs = '5';

-- what model of glasses sell most frequently
select model_name as 'Model', count(*) as 'Number of pairs sold' 
from purchase
group by model_name
order by count(*) desc;

-- what gender style of glasses sell most frequently
select style, count(*) as 'Number of pairs sold'
from purchase
group by style
order by count(*) desc;