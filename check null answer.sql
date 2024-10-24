-- check if question = 'Which brand do you want to know about?' has null answer
select *
from ecrm.contact_survey_data_maps csdm 
join ecrm.contacts c 
on csdm.contact_date = c.contact_date 
where c.contact_date = '10-23-2024'
and c.campaign_id = 73
and question like '%Which brand do you want to know about?%'
and answer is null