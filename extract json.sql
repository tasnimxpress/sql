--- decive info
select user_id ,
contact_date ,
device_info::json->'brand' as brand,
device_info::json->'model' as model,
device_info::json->'device_id' as device_id,
device_info::json->'ip_address' as ip_address
from ecrm.contacts c
where user_id = 18252 
and campaign_id = 77
group by user_id,contact_date, device_info;



{"imei": "not_found", 
"brand": "samsung", 
"model": "SM-T295", 
"device_id": "218c7a0239c1f15f", 
"user_type": "user", 
"ip_address": "192.168.100.69", 
"ui_version": "T295XXU4CUF7", 
"api_version": "30", "app_version": "e-1.0.4.3", 
"manufacture": "samsung", 
"network_type": "wifi", 
"mobile_number": "", 
"security_patch": "2021-05-01", 
"android_version": "11", 
"app_version_code": 1043}