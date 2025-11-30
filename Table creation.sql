DROP TABLE IF EXISTS "accidents_raw";
CREATE TABLE "accidents_raw" (
  "Accident_Index"                               text,
  "Location_Easting_OSGR"                        text,
  "Location_Northing_OSGR"                       text,
  "Longitude"                                    text,
  "Latitude"                                     text,
  "Police_Force"                                 text,
  "Accident_Severity"                            text,
  "Number_of_Vehicles"                           text,
  "Number_of_Casualties"                         text,
  "Date"                                         text,
  "Day_of_Week"                                  text,
  "Time"                                         text,
  "Local_Authority_(District)"                   text,
  "Local_Authority_(Highway)"                    text,
  "1st_Road_Class"                               text,
  "1st_Road_Number"                              text,
  "Road_Type"                                    text,
  "Speed_limit"                                  text,
  "2nd_Road_Class"                               text,
  "2nd_Road_Number"                              text,
  "Pedestrian_Crossing-Human_Control"            text,
  "Pedestrian_Crossing-Physical_Facilities"      text,
  "Light_Conditions"                             text,
  "Weather_Conditions"                           text,
  "Road_Surface_Conditions"                      text,
  "Urban_or_Rural_Area"                          text,
  "Did_Police_Officer_Attend_Scene_of_Accident"  text,
  "LSOA_of_Accident_Location"                    text,
  "Year"                                         text,
  "Month"                                        text,
  "Day"                                          text,
  "Weekday"                                      text,
  "Hour"                                         text,
  "Time_of_Day"                                  text
);


copy "accidents_raw"
FROM 'C:/temp/cleaned_UK_Accident.csv'
CSV HEADER QUOTE '"' ESCAPE '"'


select * from accidents_raw limit 5



DROP TABLE IF EXISTS "accidents_pbi";
CREATE TABLE "accidents_pbi" (
  "Accident_Index" text PRIMARY KEY,
  "Location_Easting_OSGR" numeric,
  "Location_Northing_OSGR" numeric,
  "Longitude" numeric,
  "Latitude" numeric,
  "Police_Force" integer,
  "Accident_Severity" text,
  "Number_of_Vehicles" integer,
  "Number_of_Casualties" integer,
  "Date" date,
  "Day_of_Week" integer,
  "Time" time,
  "Local_Authority_(District)" text,
  "Local_Authority_(Highway)" text,
  "1st_Road_Class" text,
  "1st_Road_Number" integer,
  "Road_Type" text,
  "Speed_limit" integer,
  "2nd_Road_Class" integer,
  "2nd_Road_Number" integer,
  "Pedestrian_Crossing-Human_Control" text,
  "Pedestrian_Crossing-Physical_Facilities" text,
  "Light_Conditions" text,
  "Weather_Conditions" text,
  "Road_Surface_Conditions" text,
  "Urban_or_Rural_Area" integer,
  "Did_Police_Officer_Attend_Scene_of_Accident" text,
  "LSOA_of_Accident_Location" text,
  "Year" integer,
  "Month" integer,
  "Day" integer,
  "Weekday" text,
  "Hour" integer,
  "Time_of_Day" text
);

DELETE FROM accidents_raw
WHERE "Accident_Index" !~ '^[A-Za-z0-9]+$';



INSERT INTO "accidents_pbi"
SELECT
  "Accident_Index",
  NULLIF("Location_Easting_OSGR",'')::numeric,
  NULLIF("Location_Northing_OSGR",'')::numeric,
  NULLIF("Longitude",'')::numeric,
  NULLIF("Latitude",'')::numeric,
  NULLIF("Police_Force",'')::int,
  "Accident_Severity",
  NULLIF("Number_of_Vehicles",'')::int,
  NULLIF("Number_of_Casualties",'')::int,
  NULLIF("Date",'')::date,
  NULLIF("Day_of_Week",'')::int,
  CASE
    WHEN lower("Time") IN ('unknown','') THEN NULL
    WHEN "Time" ~ '^\d{1,2}:\d{2}$'       THEN ("Time"||':00')::time
    WHEN "Time" ~ '^\d{1,2}:\d{2}:\d{2}$' THEN "Time"::time
    ELSE NULL
  END,
  "Local_Authority_(District)",
  "Local_Authority_(Highway)",
  "1st_Road_Class",
  NULLIF("1st_Road_Number",'')::int,
  "Road_Type",
  NULLIF("Speed_limit",'')::int,
  NULLIF("2nd_Road_Class",'')::int,
  NULLIF("2nd_Road_Number",'')::int,
  "Pedestrian_Crossing-Human_Control",
  "Pedestrian_Crossing-Physical_Facilities",
  "Light_Conditions",
  "Weather_Conditions",
  "Road_Surface_Conditions",
  NULLIF("Urban_or_Rural_Area",'')::int,
  "Did_Police_Officer_Attend_Scene_of_Accident",
  "LSOA_of_Accident_Location",
  NULLIF("Year",'')::int,
  NULLIF("Month",'')::int,
  NULLIF("Day",'')::int,
  "Weekday",
  NULLIF("Hour",'')::int,
  "Time_of_Day"
FROM "accidents_raw";


select * from accidents_pbi limit 5
