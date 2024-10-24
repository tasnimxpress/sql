--matched cluster update
with cluster_contacts as 
(
select 
--c.id ,
c.contacted_br,
c.contact_date,
c.campaign_id,
c.location_id ,
ou.name ccluster,
ou.type,ou.active ,
cl.name croute,
ro.id cpoint_id,
ro.name cpoint,
po.name cterritory,
ter.name cterriotory,
ar.name cregion
from
ecrm.contacts c
left join ecrm.locations ou on c.location_id = ou.id 
left join ecrm.locations cl on ou.parent = cl.id 
left join ecrm.locations ro on cl.parent =ro.id 
left join ecrm.locations po on ro.parent = po.id 
left join ecrm.locations ter on po.parent = ter.id 
left join ecrm.locations ar on ter.parent = ar.id 
left join ecrm.locations re on ar.parent = re.id 
where
ou.type = 7 -- from cluster
--and c.contact_date between '2024-10-20' and '2024-10-22'
group by 
c.contacted_br,
c.contact_date,
c.campaign_id,
c.location_id ,
ou.name,
ou.type,
ou.active ,
cl.name,
ro.id,
ro.name,
po.name,
ter.name,
ar.name -- Retrieve the locations that contain clusters in outlet positions.
)
--select distinct location_id, type from cluster_contacts; -- 277
all_locations as 
(
select 
re.id region_id 
,re.name region
,re.active ractive
,ar.id area_id 
,ar.name area
,ar.active aactive
,ter.id territory_id
,ter.name territory 
,ter.active tactive
,po.id point_id
,po.name point
,po.active pactive
,ro.id route_id
,ro.name route
,ro.active roactive
,cl.id cluster_id
,cl.name cluster_new
,cl.active cactive
,ou.id outlet_id 
,ou.name outlet
,ou.active oactive
from 
ecrm.locations ou
left join ecrm.locations cl on ou.parent = cl.id 
left join ecrm.locations ro on cl.parent =ro.id 
left join ecrm.locations po on ro.parent = po.id 
left join ecrm.locations ter on po.parent = ter.id 
left join ecrm.locations ar on ter.parent = ar.id 
left join ecrm.locations re on ar.parent = re.id 
where ou.type = 8
--and ou.id = 1199508
),
matched_and_active as
(
select 
--count(distinct (cc.id))
cc.id contact_id,cc.contacted_br,cc.location_id,cc.ccluster,cc.croute,cc.cpoint_id,cc.cpoint,al.cluster_id,al.cluster_new,al.route,
case when al.point_id = 2337 then 1199508 
--	when al.point_id = 2462 then 1471249
--	when al.point_id = 2463 then 1471250 
	else al.point_id end as point_id,
case when al.point_id = 2337 then 'MT-Banani'
--	when al.point_id = 2462 then 'Keranihat (MAQ)'
--	when al.point_id = 2463 then 'Bandarban (MAQ)'
	else al."point" end as point
,al.cactive
,case when (cc.location_id = al.cluster_id and cc.croute = al.route and cc.cpoint_id = al.point_id) 
or (cc.ccluster = al.cluster_new and cc.cpoint_id = al.point_id and al.cactive is true) 
then 'match' else 'unmatched' end as _matched
from 
cluster_contacts cc
left join all_locations al on cc.ccluster = al.cluster_new
group by cc.id,cc.contacted_br,cc.location_id,cc.ccluster,cc.croute,cc.cpoint_id,
cc.cpoint,al.cluster_id,al.cluster_new,al.route,al.point_id,al.point,al.cactive)
--select * from matched_and_active;
,
--ccount as
--(
--select
--contact_id, count(contact_id)
--from 
--matched_and_active
--group by contact_id
--having count(contact_id) >1
--),
ranking as
(
select 
row_number  () over (partition by ma.contact_id order by ma.contact_id) rnum,
--count(distinct (ma.contact_id))
ma.*
--,ccount."count"
from 
matched_and_active ma
--join ccount ccount on ma.contact_id = ccount.contact_id
--where 
--_matched = 'match'
--and ccount."count" >1 
--and "point" not in ('MT-Banani')
order by contact_id,contacted_br)
select * from ranking;
,
last_ranking as 
(select 
--count(distinct(contact_id))
row_number () over (partition by contact_id order by contact_id) rrum,
*
from
ranking
 where
 cluster_id is NOT null
 and cactive is true
 and _matched = 'match'),
 final_matched as
( select 
--count(distinct cluster_id) 
contact_id ,contacted_br,cluster_id,_cluster
 from 
 last_ranking 
 where 
 rrum = 1),
 replaced_outlets as
 (SELECT
	parent , 
	id outlet_id
from 
(SELECT
-- count (DISTINCT parent)
ROW_NUMBER () over (PARTITION by parent order by id ) rnum,
*
from ecrm.locations
where 
parent in
(
50036,59692,64502,66643,72811,81015,93046,114379,126989,130815,149260,958999,961099,964200,969731,971855,972848,974133,974624,
976219,978600,987129,988264,1275749,1442578,1442715,1443155,1443174,1443281,1443290,1443323,1443364,1443420,1443434,1443737,
1443838,1444026,1444046,1444319,1444349,1444803,1444804,1444970,1444974,1445136,1445148,1445286,1445295,1445393,1445489,1445624,
1446067,1446121,1446169,1446292,1446335,1446574,1446720,1446870,1447090,1447130,1447308,1447310,1447313,1447477,1447568,1447802,
1448017,1448039,1448456,1448457,1448464,1448600,1448601,1448696,1448700,1448703,1448704,1448736,1448747,1448750,1448751,1448957,
1449200,1449453,1449544,1449787,1449803,1449806,1449819,1449902,1450065,1450089,1450117,1450136,1450170,1450240,1450242,1450440,
1450540,1450554,1450624,1450640,1451521,1451524,1451550,1451652,1451715,1451749,1452263,1452542,1452811,1452915,1452989,1453070,
1453185,1453222,1453641,1453642,1454255,1454467,1454516,1454521,1454541,1454544,1455364,1455434,1455630,1455632,1455634,1455635,
1455850,1455949,1455953,1455968,1456023,1456024,1456076,1456295,1456470,1456606,1456692,1457481,1457613,1459183,1459301,1460343,
1462857,1464959,1467435,1467499,1468095)
and active is true )a
where 
rnum = 1)
--update ecrm.contacts c
--set location_id = a.outlet_id
--from
--(
select 
--array_agg(contact_id) 
contact_id, contacted_br,parent,outlet_id
from 
final_matched f 
join replaced_outlets o on f.cluster_id = o.parent
--)a
--where a.contact_id = c.id;