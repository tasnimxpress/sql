--contacts, survey datamap, users, sku_items, location, users_info, 

select *
from ecrm.users 
limit 5 ;

select * 
from ecrm.supervisor_contacts sc 
limit 5 ;

select c.id, c.user_id , c.campaign_version,
cast(c.additional_info->> 'end_time' as time) as end_time, 
c.additional_info::json -> 'tap_analysis' as tap_analysis,
c.additional_info::json-> '$.tap_analysis.result[*].tap_time' as tap
from ecrm.contacts as c
limit 10 ;



SELECT
    id,
    additional_info->>'campaign_name' AS campaign_name,
    additional_info ->> 'location_name' as location,
    MAX(CASE WHEN tap_analysis->>'question' = 'signature' THEN tap_results->>'tap_time' END) AS signature_tap_time,
    MAX(CASE WHEN tap_analysis->>'question' = 'leisure_work' THEN tap_results->>'tap_time' END) AS leisure_work_tap_time,
    MAX(CASE WHEN tap_analysis->>'question' = 'otp' THEN tap_results->>'tap_time' END) AS otp_tap_time,
    MAX(CASE WHEN tap_analysis->>'question' = 'attire_style' THEN tap_results->>'tap_time' END) AS attire_style_tap_time,
    MAX(CASE WHEN tap_analysis->>'question' = 'mobile_phone_brand' THEN tap_results->>'tap_time' END) AS mobile_phone_brand_tap_time
FROM 
    ecrm.contacts,
    jsonb_array_elements(additional_info->'tap_analysis') AS tap_analysis,
    jsonb_array_elements(tap_analysis->'result') AS tap_results
GROUP BY id, additional_info->>'campaign_name'
limit 10;



select c.id, 
c.additional_info->> 'campaign_name' as campaign_name,
c.additional_info->> 'location_name' as location,
max(case when tap->>'question'= 'signature' and tap_result->> 'option' = 'signature' then tap_result->> 'tap_time' end) as signature_tap_time,
max(case when tap->>'question'= 'signature' and tap_result->> 'option' = 'sign_agree_btn' then tap_result->> 'tap_time' end) as sign_agree_btn_tap_time
from ecrm.contacts c ,
jsonb_array_elements(additional_info-> 'tap_analysis') as tap,
jsonb_array_elements(tap-> 'result') as tap_result
where c.additional_info->> 'campaign_name' = 'PJ Normandy'
group by c.id, c.additional_info ->> 'campaign_name'
limit 10;

select *
from ecrm.contacts c 
where id = 43
limit 20 ;

select *
from ecrm.roles r
limit 5 ;