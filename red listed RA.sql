--60 red RA list ,
--aita ektu check korte hobe , eder contact time asholei 7min > Contact Duration >12min kina

with tbl as 
(
select
	c.user_id,
	u.username,
	c.campaign_id,
	c.start,
	c.end,
	"end"::time - "start"::time as duration,
	l1.name as outlet,
	l2.name as cluster,
	l3.name as point,
	l4.name as route,
	l5.name as territory,
	l6.name as area,
	l7.name as region
from
	ecrm.contacts c
join ecrm.users u 
on
	c.user_id = u.id
join ecrm.locations l1
on
	c.location_id = l1.id
left join ecrm.locations l2 on
	l2.id = l1.parent
left join ecrm.locations l3 on
	l3.id = l2.parent
left join ecrm.locations l4 on
	l4.id = l3.parent
left join ecrm.locations l5 on
	l5.id = l4.parent
left join ecrm.locations l6 on
	l6.id = l5.parent
left join ecrm.locations l7 on
	l7.id = l6.parent
where
	campaign_id = 77
	and c.contact_date = '2024-10-07'
	and username in(
'anowarhosen404@ecrm-imsl',
'brsyl19336@ecrm-atmsl',
'brsyl3040@ecrm-atmsl',
'brsyl41108@ecrm-atmsl',
'brsyl41106@ecrm-atmsl',
'brkhu7013@ecrm-imsl',
'brsyl24032@ecrm-atmsl',
'istiakbrraj2606@ecrm-ims',
'brsyl24912@ecrm-atmsl',
'brraj882612@ecrm-ims',
'brsyl30005@ecrm-atmsl',
'janealam3182@ecrm-imsl',
'brkhu16719@ecrm-imsl',
'brsyl19100@ecrm-atmsl',
'brctg277017@ecrm-imsl',
'brsyl3036@ecrm-atmsl',
'brkhu2099@ecrm-imsl',
'brctg20768@ecrm-imsl',
'brctg27345@ecrm-ims',
'brsyl3037@ecrm-atmsl',
'md.ekbalhossain15830@ecrm-imsl',
'brraj56103@ecrm-ims',
'brkhu9401@ecrm-imsl',
'brdhk4690@ecrm-imsl',
'md.munzilhossain7388@ecrm-imsl',
'kamrul@ecrm-atmsl',
'rakibhasan27797@ecrm-imsl',
'brsyl313@ecrm-atmsl',
'brsyl292@ecrm-atmsl',
'brraj67673@ecrm-ims',
'brkhu2005@ecrm-ims',
'fahim2006@ecrm-imsl',
'surifulullah13026@ecrm-imsl',
'brsyl6689@ecrm-atmsl',
'mehedi4321@ecrm-ims',
'mohammadyounusbrctg119@ecrm-ims',
'brsyl2222@ecrm-atmsl',
'bishaldas16892@ecrm-imsl',
'brsyl312@ecrm-atmsl',
'brsyl202424@ecrm-atmsl',
'ridoybrraj626@ecrm-ims',
'brctg23546@ecrm-imsl',
'kaushik123@ecrm-imsl',
'brsyl6148@ecrm-atmsl',
'jobayerahmed@ecrm-atmsl',
'brraj2093@ecrm-ims',
'brkhu21259@ecrm-imsl',
'touhid1998@ecrm-imsl',
'herasarkar11@ecrm-ims',
'asikbrraj2930@ecrm-ims',
'brkhu2389@ecrm-imsl',
'brkhu6559@ecrm-imsl',
'brkhu021997@ecrm-ims',
'sojibbepari86@ecrm-imsl',
'brkhu2535@ecrm-imsl',
'ayatullahislam2@ecrm-imsl',
'mdrazib@ecrm-imsl',
'alamgir0023@ecrm-ims',
'bkrhanulbrraj579@ecrm-ims',
'brkhu24759@ecrm-imsl'
)),
main as(
select
	* ,
	avg(duration) over(partition by user_id) as "avg_duration"
from
	tbl
),
base as (
select
	*,
	case
		when avg_duration < '00:12:00'
			or avg_duration < '00:07:00' then 'Red'
			else 'green'
		end as category
	from
		main)
select
	* ,
	case
		when category = 'Red' then count(user_id) over(partition by user_id)
	end as red_count
from
	base
where
	category = 'green'
group by
	user_id,
	username,
	campaign_id,
	"start",
	"end",
	duration,
	outlet,
	cluster,
	point,
	route,
	territory,
	area,
	region,
	avg_duration,
	category;




----- by unique user
with tbl as (
select
	c.id,
	c.user_id,
	u.username,
--	c.campaign_id,
	"start",
	"end",
	contact_date,
	"end"::time - "start"::time as duration,
	l4.name as point,
	l5.name as territory,
	l6.name as area,
	l7.name as region
from
	ecrm.contacts c
left join ecrm.users u 
    on
	c.user_id = u.id
join ecrm.locations l1
    on
	c.location_id = l1.id
left join ecrm.locations l2 
    on
	l2.id = l1.parent
left join ecrm.locations l3 
    on
	l3.id = l2.parent
left join ecrm.locations l4 
    on
	l4.id = l3.parent
left join ecrm.locations l5 
    on
	l5.id = l4.parent
left join ecrm.locations l6 
    on
	l6.id = l5.parent
left join ecrm.locations l7 
    on
	l7.id = l6.parent
where
	l7.active is not null
	and
    campaign_id = 77
    and start::time <= '13:00:00'
--	    and c.contact_date = '2024-10-07'
	--    and user_id = 687
),
--select * from tbl; 
--select count(distinct user_id) from tbl ; count 1075, expected 1095
main as (
select
	id,
	user_id,
	username,
--	campaign_id,
	point,
	territory,
	area,
	region,
	"start",
	"end",
	contact_date,
	duration,
	avg(duration) over (partition by user_id) as avg_duration,
	case
		when duration > '00:12:00'
			or duration < '00:07:00' 
      then 'Red'
			else 'Green'
		end as duration_category
	from
		tbl
)
select
	*
from
	main;
-- per contact category
summary as 
(
select
	* ,
	case
		when duration_category = 'Red' then 1
	end as red_count,
	case
		when duration_category = 'Green' then 1
	end as green_count
from
	main
group by
	user_id,
	username,
	campaign_id,
	point,
	territory,
	area,
	region,
	duration,
	avg_duration,
	duration_category
  ),
base as (
select
	*,
	case
		when avg_duration > '00:12:00'
			or avg_duration < '00:07:00' 
      then 'Red'
			else 'Green'
		end as avg_category
	from
		summary
	group by
		user_id,
		username,
		campaign_id,
		--    duration,
		point,
		territory,
		area,
		region,
		duration,
		duration_category,
		avg_duration,
		red_count,
		green_count
)
select
	user_id,
	username,
	campaign_id,
	--    duration,
	point,
	territory,
	area,
	region,
	--    duration,
	--    duration_category,
	avg_duration,
	avg_category,
	--    red_count,
	--    green_count,
	count(red_count) as red_count,
	count(green_count) as green_count
from
	base
group by
	user_id,
	username,
	campaign_id,
	--    duration,
	point,
	territory,
	area,
	region,
	--    duration,
	--    duration_category,
	avg_duration,
	--    red_count,
	--    green_count,
	avg_category;
	--where avg_category = 'Red';
	--where category = 'Red'
	--order by user_id; 



	-- total BR count;
select count(distinct user_id) as "Total_RA"
from ecrm.contacts c 
where campaign_id = 77
and "start"::time <= '13:00:00' ;


-- total contact count
select
	count(c.id) as "Total_contact"
from ecrm.contacts c 
where
	c.campaign_id = 77
	and "start"::time <= '13:00:00' ;

