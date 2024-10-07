--- SQL - Daily raw report template
--create extension if not exists tablefunc;
-- contacts and consumer tbl; contacts details , consumer details
with base as
(
select 
	c.id as "Contact ID",
	c.location_id,
	c.user_id,
	c3.name as "Campaign Name",
	c.giveable as "PTR",
	c.contact_date as "Contact_Date",
	c2.name as "Consumer Name",
	c2.contact_no as "Consumer Number",
	c2.fathers_name as "Consumers Fathers Name",
	age(current_date, c2.dob) as "Consumer Age",
	c2.address as "Consumer Address",
	c.product as "Primary brand", 
	c.secondary_brand as "Secondary Brand", 
	c.start as "Contact Start", 
	c.end as "Contact End",
	cast(c.end as time) - cast(c.start as time) as "Contact Duration"
from
	ecrm.contacts c
left join ecrm.consumers c2
	on
	c.consumer_id = c2.id
join ecrm.campaigns c3
	on
	c.campaign_id = c3.id
where
	c.campaign_id = 77
	and c.contact_date = '2024-10-07'
	and c.start::time <= '13:00:00'
	and c.id not in (
5245268, 5245170, 5245188,5245111,5245224,5245026,5245219,5245189,5245196,5245070,5245187,5245003,5244973,5245200,5245123,5245193,5245390,
5245206,5245294,5244952,5245179,5245152,5245097,5245055,5245257,5245204,5245242,5245145,5245082,5245102,5245141,5245299,5245114,5245034,
5245106,5244972,5244971,5245165,5245220,5245160,5245041,5245120,5244944,5245005,5244969,5245162,5245171,5245002,5245009,5245006,5245339,
5245086,5245293,5244947,5245285,5245151,5245050,5245229,5245085,5244976,5245105,5245209,5245351,5245166,5244966,5245113,5245163,5244996,
5245173,5245222,5245023,5245256,5244957,5244954,5244950,5245405
)
),
--select * from base;  -- count actual 8301, expected 8941
-- user infos, locations tbl; user details and location details
user_and_loc_details as
(
select
	b.*,
	u.username as "User Name",
	ui.full_name as "BR name",
	u.uid as "BR code",
	l1.name as "Outlet Name",
	l2.name as "Cluster Name",
	l3.name as "Routes",
	l4.name as "Distributors point",
	l5.name as "Territory",
	l6.name as "Area",
	l7.name as "Region"
from
	base b
left join ecrm.users u
on
	b.user_id = u.id
left join  ecrm.user_infos ui  
on
	u.id = ui.user_id
left join ecrm.locations l1 on 
	b.location_id = l1.id
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
),
--select * from user_and_loc_details; -- count actual 8301
-- survey maps; questions and answer
survey_map as (
select
	*
from
	crosstab(
$$
	select
		contact_id,
		question,
		answer
	from
		ecrm.contacts c
	join ecrm.contact_survey_data_maps csdm
on
		c.id = csdm.contact_id
where 
	c.campaign_id = 77
	and c.contact_date = '2024-10-07'
	and c."start"::time <= '13:00:00'
group by csdm.contact_id, question, answer
$$,
		$$
	values 
	('lifestyle_av'),
	('product_av'),
	('bongo_serial'),
	('trial_option'),
	('like_new_cig_select'),
	('like_new_cig_deluxe'),
	('like_new_pack_select'),
	('like_new_pack_deluxe'),
	('try_new_cig_again_select'),
	('try_new_cig_again_deluxe'),
	('bongo_or_tea'),
	('use_smartphone')
$$
) as pivot_table(
	id INT,
	lifestyle_av text,
	product_av text,
	bongo_serial text,
	trial_option text,
	like_new_cig_select text,
	like_new_cig_deluxe text,
	like_new_pack_select text,
	like_new_pack_deluxe text,
	try_new_cig_again_select text,
	try_new_cig_again_deluxe text,
	bongo_or_tea text,
	use_smartphone text)
) -- return count 8301
--select * from survey_map; 
-- organize column as required and final output
main as
(
select
	"Contact ID",
	"Region",
	"Area",
	"Territory",
	"Distributors point",
	"Routes",
	"Cluster Name",
	"Outlet Name",
	"User Name",
	case
		when "Region" = 'Rajshahi' then 'Integrated Marketing Service Ltd.'
		when "Region" = 'Sylhet' then 'Asiatic Trade Marketing Services Limited'
		else 'IMSL'
	end as "Agency",
	"BR name",
	"BR code",
	"Campaign Name",
	"Contact_Date",
	"Consumer Name",
	"Consumer Number",
	"Consumers Fathers Name",
	"Consumer Age",
	"Consumer Address",
	si.sku_name as "Primary Brand Name",
	si2.sku_name as "Secondary Brand Name",
	m.name as "PTR_Name",
	"Contact Start",
	"Contact End",
	"Contact Duration",
	lifestyle_av,
	product_av,
	bongo_serial,
	trial_option,
	like_new_cig_select,
	like_new_cig_deluxe,
	like_new_pack_select,
	like_new_pack_deluxe,
	try_new_cig_again_select,
	try_new_cig_again_deluxe,
	bongo_or_tea,
	use_smartphone
from
	user_and_loc_details uld
join survey_map
on
	uld."Contact ID" = survey_map.id
left join ecrm.materials m
on
	uld."PTR" = m.id
join ecrm.sku_items si 
on 
	"Primary brand" = si.id
join ecrm.sku_items si2
on 
	"Secondary Brand" = si2.id)
select *
from main;



--- verify survey data map count -- 8301
select
	count(distinct csdm.contact_id)
from
	ecrm.contact_survey_data_maps csdm
join ecrm.contacts c 
on
	csdm.contact_id = c.id
where
	c.campaign_id = 77
	and csdm.contact_date = '2024-10-07'
	and "start"::time <= '13:00:00' ;



--- verify contacts count -- 8373
select
	count(id)
from
	ecrm.contacts c
where
	campaign_id = 77
	and contact_date = '2024-10-07'
	and "start"::time <= '13:00:00' ;



--- finding missing data from survey map - missing 72 ids
select
	c.id
from
	ecrm.contacts c
left join ecrm.contact_survey_data_maps csdm 
on
	c.id = csdm.contact_id
where
	csdm.id is null
	and c.contact_date = '2024-10-07'
	and c.start::time <= '13:00:00';
	

-- username NULL
select *
from ecrm.contacts c
join ecrm.users ui 
on c.user_id = ui.id
where campaign_id = 77
and ui.id = 813;


------ checking address bottol
select *
from ecrm.contacts c 
join ecrm.consumers c2 
on c.consumer_id = c2.id
where c.id = 5247701