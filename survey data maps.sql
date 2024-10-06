select c.id, csdm.contact_id, question_id , question, answer , c.user_id 
from ecrm.contact_survey_data_maps csdm 
join ecrm.contacts c 
on csdm.contact_id = c.id
where c.campaign_id = 77
and c.id = 5236963
and csdm.contact_date = '2024-10-06';

-------------p
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT *
FROM crosstab(
    $$
    SELECT 
        contact_id,
        question_id,
        answer
    FROM ecrm.contact_survey_data_maps csdm 
	JOIN ecrm.contacts c 
	ON csdm.contact_id = c.id
	WHERE c.campaign_id = 77
--	and c.id = 5205121
	AND csdm.contact_date > '2024-10-05'
    ORDER BY contact_id, question_id
    $$,
    $$ 
    VALUES (1), (2), (3), (4), (11), (13), (15), (22), (28), (29), (101)
    $$
) AS pivot_table (
    contact_id INT,
    question_1 TEXT,
    question_2 TEXT,
    question_3 TEXT,
    question_4 TEXT,
    question_11 TEXT,
    question_13 TEXT,
    question_15 TEXT,
    question_22 TEXT,
    question_28 TEXT,
    question_29 TEXT,
    question_101 TEXT
);




SELECT *
FROM crosstab(
    $$
    SELECT 
        contact_id,
        question,
        answer
    FROM ecrm.contact_survey_data_maps csdm 
	JOIN ecrm.contacts c 
	ON csdm.contact_id = c.id
	WHERE c.campaign_id = 77
	and c.id = 5236963
	AND csdm.contact_date = '2024-10-06'
    ORDER BY contact_id, question_id
    $$,
    $$ 
    VALUES ('product'),
	('secondary_brand'),
	('contact_no'),
	('dob'),
	('name'),
	('fathers_name'),
	('address'),
	('signature'),
	('otp'),
	('lifestyle_av'),
	('product_av'),
	('giveable'),
	('trial_option'),
	('like_new_cig_select'),
	('like_new_pack_select'),
	('try_new_cig_again_select'),
	('option_selection'),
	('bongo_or_tea'),
	('use_smartphone'),
	('audio')
    $$
) AS pivot_table (
    contact_id INT,
	product text,
	secondary_brand text,
	contact_no text,
	dob text,
	name text,
	fathers_name text,
	address text,
	signature text,
	otp text,
	lifestyle_av text,
	product_av text,
	giveable text,
	trial_option text,
	like_new_cig_select text,
	like_new_pack_select text,
	try_new_cig_again_select text,
	option_selection text,
	bongo_or_tea text,
	use_smartphone text,
	audio text
);


