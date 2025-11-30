--Queries 

select * from accidents_pbi limit 2
--1.Total accidents, casualties, and vehicles

select count(*),
sum("Number_of_Casualties") as total_casualties,
sum("Number_of_Vehicles") as total_vehicles
from accidents_pbi

--2 severtiy distribution

with sev as(
	select "Accident_Severity",count(*) as cnt
	from Accidents_pbi group by "Accident_Severity"
)
select "Accident_Severity",
round(100*cnt/sum(cnt) over(),2 ) as share
from sev 

--3 Accident by Hours(top 10)

select "Hour",count(*) as accident
from accidents_pbi 
where "Hour">=0
group by "Hour" order by accident desc
limit 10

--4 Accidents by time of day

select "Time_of_Day" , count(*) as accident
from accidents_pbi
group by "Time_of_Day"
order by accident desc 

--5 Accident by Weekday

select "Weekday",count(*) as accident
from accidents_pbi group by "Weekday"
order by array_position(
array['Monday','Tuesday','Wednesday',
'Thursday','Friday','Saturday','Sunday'],"Weekday"
)

--6 Monthly aciident Trend

SELECT "Month", COUNT(*) AS accidents
FROM accidents_pbi
GROUP BY "Month"
ORDER BY "Month";

--7 Yearly Accident Trend

SELECT "Year", COUNT(*) AS accidents
FROM accidents_pbi
GROUP BY "Year"
ORDER BY "Year";

--8 Top 15 most accident-prone districts?

SELECT "Local_Authority_(District)", COUNT(*) AS accidents
FROM accidents_pbi
GROUP BY "Local_Authority_(District)"
ORDER BY accidents DESC
LIMIT 15;

--9 Severity % by light conditions

SELECT "Light_Conditions",
ROUND(100.0 * SUM(CASE WHEN "Accident_Severity"='Fatal' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fatal_pct,
ROUND(100.0 * SUM(CASE WHEN "Accident_Severity"='Serious' THEN 1 ELSE 0 END) / COUNT(*), 2) AS serious_pct,
ROUND(100.0 * SUM(CASE WHEN "Accident_Severity"='Slight' THEN 1 ELSE 0 END) / COUNT(*), 2) AS slight_pct
FROM accidents_pbi
GROUP BY "Light_Conditions"
ORDER BY fatal_pct DESC;

--10 Weather impact by fatality rate

SELECT 
"Weather_Conditions",
COUNT(*) AS accidents, 
ROUND(100.0 *
SUM(CASE WHEN "Accident_Severity"='1' THEN 1 ELSE 0 END) / COUNT(*), 2)
AS fatal_rate_pct
FROM accidents_pbi
GROUP BY "Weather_Conditions"
HAVING COUNT(*) > 100
ORDER BY fatal_rate_pct DESC;

--11 speed limitt vs accident fatal

SELECT
"Speed_limit",
COUNT(*) AS accidents,
SUM(CASE WHEN "Accident_Severity"='1' THEN 1 ELSE 0 END) AS fatal_count,
ROUND(100.0 * SUM(CASE WHEN "Accident_Severity"='1' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fatal_rate_pct
FROM accidents_pbi
GROUP BY "Speed_limit"
ORDER BY "Speed_limit";

--12 Urban vs rural analysis

SELECT
CASE WHEN "Urban_or_Rural_Area" = 1 THEN 'Urban'
WHEN "Urban_or_Rural_Area" = 2 THEN 'Rural'
ELSE 'Unknown'
END AS area_type,
COUNT(*) AS accidents,
ROUND(100.0 * SUM(CASE WHEN "Accident_Severity"='1' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fatal_pct,
ROUND(100.0 * SUM(CASE WHEN "Accident_Severity"='2' THEN 1 ELSE 0 END) / COUNT(*), 2) AS serious_pct
FROM accidents_pbi
GROUP BY area_type
ORDER BY accidents DESC;


--13 Average casualties by severity

SELECT 
"Accident_Severity",
ROUND(AVG("Number_of_Casualties"), 2) AS avg_casualties
FROM accidents_pbi
GROUP BY "Accident_Severity"
ORDER BY avg_casualties DESC;



--14 Most dangerous hour × speed limit combinations

SELECT 
"Hour",
"Speed_limit",
COUNT(*) AS accidents,
ROUND(100.0 * SUM(CASE WHEN "Accident_Severity"='1' THEN 1 ELSE 0 END)
/ COUNT(*), 2) AS fatal_rate_pct
FROM accidents_pbi
WHERE "Hour" >= 0
GROUP BY "Hour", "Speed_limit"
HAVING COUNT(*) >= 200
ORDER BY fatal_rate_pct DESC
LIMIT 15;


