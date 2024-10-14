-- Step 1: tbl - Fetch all contacts made by users, including duration (end - start)
WITH tbl AS
    (SELECT c.id,
            c.user_id,
            u.username,
            c."start",
            c."end",
            c.contact_date,
            c."end"::TIME - c."start"::TIME AS duration,
            l4.name AS POINT,
            l5.name AS territory,
            l6.name AS area,
            l7.name AS region
     FROM ecrm.contacts c
     LEFT JOIN ecrm.users u ON c.user_id = u.id
     JOIN ecrm.locations l1 ON c.location_id = l1.id
     LEFT JOIN ecrm.locations l2 ON l2.id = l1.parent
     LEFT JOIN ecrm.locations l3 ON l3.id = l2.parent
     LEFT JOIN ecrm.locations l4 ON l4.id = l3.parent
     LEFT JOIN ecrm.locations l5 ON l5.id = l4.parent
     LEFT JOIN ecrm.locations l6 ON l6.id = l5.parent
     LEFT JOIN ecrm.locations l7 ON l7.id = l6.parent
     WHERE c.campaign_id = 77
         AND l7.active IS NOT NULL 
--         AND c.contact_date <= '2024-10-08'
--         AND c."start"::time <= '16:45:00' ---CURRENT_TIME
--         AND c.user_id = 715  -- Uncomment to filter by specific user ID
	ORDER BY user_id), --select * from tbl ;
-- Step 2: base - Calculate average duration and categorize each contact's duration
base AS 
    (SELECT id, 
            user_id, 
            username, 
            "start", 
            "end", 
            contact_date, 
            duration, 
            POINT, 
            territory, 
            area, 
            region, 
            count(id) OVER (PARTITION BY user_id) total_contact_by_user, 
 -- Categorize duration based on predefined benchmark:
 -- Red:    Contact Duration > 12 min or < 7 min
 -- Amber:  10 min < Contact Duration <= 12 min
 -- Green:  7 min <= Contact Duration <= 10 min
	 CASE   
        WHEN duration > '00:12:00' OR duration < '00:07:00' THEN 'Red'
        WHEN duration > '00:10:00' AND duration <= '00:12:00' THEN 'Amber'
        WHEN duration >= '00:07:00' AND duration <= '00:10:00' THEN 'Green'
	 END AS duration_category, 
	 AVG(duration) OVER (PARTITION BY user_id) AS avg_duration 
     FROM tbl) ,
--select * from base ;
--where duration_category = 'Green';
-- Step 3: detail - Count contacts per duration category and calculate average duration category
detail AS 
    (SELECT id, 
            user_id, 
            username, 
            POINT, 
            territory, 
            area, 
            region, 
            "start", 
            "end", 
            contact_date, 
            lead("start"::time) over (partition by user_id order by "start") - "end"::time  as interval,
            duration, 
            duration_category, 
	-- Count occurrences of each duration category
	 CASE 
	     WHEN duration_category = 'Red' THEN 1 
	 END AS red_count, 
	 CASE 
	     WHEN duration_category = 'Green' THEN 1 
	 END AS green_count, 
	 CASE 
	     WHEN duration_category = 'Amber' THEN 1 
	 END AS amber_count, 
	 avg_duration, 
	 -- Categorize average duration based on predefined ranges
	 CASE 
	    WHEN avg_duration > '00:12:00' OR avg_duration < '00:07:00' THEN 'Red'
        WHEN avg_duration > '00:10:00' AND avg_duration <= '00:12:00' THEN 'Amber'
        WHEN avg_duration >= '00:07:00' AND avg_duration <= '00:10:00' THEN 'Green'
	 END AS avg_duration_category, 
	 total_contact_by_user 
     FROM base)
select * from detail ;
-- Step 4: main - Summarize data by calculating total counts for each duration category
main AS 
    (SELECT user_id, 
            username, 
            POINT, 
            territory, 
            area, 
            region, 
            avg_duration::TIME, 
            avg_duration_category, 
	 -- Count total number of 'Red', 'Green', and 'Amber' contacts per user
	 COUNT(red_count) OVER (PARTITION BY user_id) AS total_red, 
	 COUNT(green_count) OVER (PARTITION BY user_id) AS total_green, 
	 COUNT(amber_count) OVER (PARTITION BY user_id) AS total_amber, 
	 total_contact_by_user
     FROM detail),
--select * from main ;
-- Step 5: summary and Final Query - Get summarized data for reporting
summary AS 
    (SELECT *
     FROM main
     GROUP BY user_id, 
              username, 
              POINT, 
              territory, 
              area, 
              region, 
              avg_duration, 
              avg_duration_category, 
              total_red, 
              total_green, 
              total_amber, 
              total_contact_by_user )
--select * from summary ;
-- Filter query (if needed)
SELECT ui.full_name, 
       s.*
FROM summary s
LEFT JOIN ecrm.user_infos ui 
ON s.user_id = ui.user_id 
--where avg_duration_category = 'Red'
