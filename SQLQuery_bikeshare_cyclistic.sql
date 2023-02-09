

--I started with by mergeing the 12 months data into 1 using union and create table

DROP TABLE if exists cyclistic_merg 
CREATE TABLE cyclistic_merg 
(rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
end_station_name nvarchar(255),
member_casual nvarchar(255),
start_lat numeric,
end_lat numeric
)
INSERT INTO cyclistic_merg
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202201-january]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202202-february]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202203-march]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202204-april]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202205-may]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202206-june]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202207-july]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202208-August]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202209-September]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202210-october]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202211-November]
UNION
SELECT rideable_type, started_at, ended_at, start_station_name, end_station_name, member_casual, start_lat, end_lat
FROM Bike_share_data..[202212-December];


SELECT COUNT(*)
FROM cyclistic_merg

-- convert ride time into minutes 

SELECT started_at, ended_at,
	DATEDIFF(minute, started_at, ended_at) AS duration_in_minutes
FROM master.dbo.cyclistic_merg 

-- After creating a column for duration in minutes i added the new column to the table

ALTER TABLE master..cyclistic_merg
ADD duration_in_minutes float

-- table was updated with the new column of duration in minutes

UPDATE master..cyclistic_merg
SET duration_in_minutes = DATEDIFF(minute, started_at, ended_at)

-- average trip duration by customer type

SELECT member_casual, AVG(duration_in_minutes) AS average_time
FROM master..cyclistic_merg
GROUP BY member_casual

-- Total trip duration 
SELECT member_casual, SUM(duration_in_minutes) AS total_trip_duration
FROM master..cyclistic_merg
GROUP BY member_casual

SELECT start_station_name, end_station_name, COUNT(DISTINCT start_station_name, end_station_name) AS station_count
FROM master..cyclistic_merg
GROUP BY start_station_name, end_station_name,
ORDER BY station_count DESC

-- created tables to know the stations with the highest traffic


SELECT start_station_name, COUNT(*) AS start_station_count
FROM master..cyclistic_merg
WHERE start_station_name is NOT NULL
GROUP BY start_station_name
ORDER BY start_station_count DESC

SELECT end_station_name, COUNT(*) AS end_station_count
FROM master..cyclistic_merg
WHERE end_station_name is NOT NULL
GROUP BY end_station_name
ORDER BY end_station_count DESC

-- displaying the count of start station and end station to know the stations with high traffic

SELECT start_station_name, COUNT(start_station_name) AS start_station_count,
	   end_station_name, COUNT(end_station_name) AS end_station_count
FROM master..cyclistic_merg
WHERE start_station_name is NOT NULL AND end_station_name is NOT NULL
GROUP BY start_station_name, end_station_name
ORDER BY start_station_count DESC, end_station_count DESC

--this table is showing the number of rides by day of the week and number of rides by month of the year

WITH rides_cte AS (
	SELECT
	DATEPART(WEEKDAY, started_at) AS day_of_week,
	DATEPART(MONTH, started_at) AS month_of_year,
	COUNT(*) AS ride_count
	FROM master..cyclistic_merg
	GROUP BY DATEPART(WEEKDAY, started_at), DATEPART(MONTH, started_at)
)
SELECT
	SUM(CASE WHEN day_of_week = 1 THEN ride_count ELSE 0 END) AS sunday_rides,
	SUM(CASE WHEN day_of_week = 2 THEN ride_count ELSE 0 END) AS monday_rides,
	SUM(CASE WHEN day_of_week = 3 THEN ride_count ELSE 0 END) AS tuesday_rides,
	SUM(CASE WHEN day_of_week = 4 THEN ride_count ELSE 0 END) AS wednesday_rides,
	SUM(CASE WHEN day_of_week = 5 THEN ride_count ELSE 0 END) AS thursday_rides,
	SUM(CASE WHEN day_of_week = 6 THEN ride_count ELSE 0 END) AS fridayday_rides,
	SUM(CASE WHEN day_of_week = 7 THEN ride_count ELSE 0 END) AS saturday_rides,
	SUM(CASE WHEN month_of_year = 1 THEN ride_count ELSE 0 END) AS january_rides,
	SUM(CASE WHEN month_of_year = 2 THEN ride_count ELSE 0 END) AS february_rides,
	SUM(CASE WHEN month_of_year = 3 THEN ride_count ELSE 0 END) AS march_rides,
	SUM(CASE WHEN month_of_year = 4 THEN ride_count ELSE 0 END) AS april_rides,
	SUM(CASE WHEN month_of_year = 5 THEN ride_count ELSE 0 END) AS may_rides,
	SUM(CASE WHEN month_of_year = 6 THEN ride_count ELSE 0 END) AS june_rides,
	SUM(CASE WHEN month_of_year = 7 THEN ride_count ELSE 0 END) AS july_rides,
	SUM(CASE WHEN month_of_year = 8 THEN ride_count ELSE 0 END) AS august_rides,
	SUM(CASE WHEN month_of_year = 9 THEN ride_count ELSE 0 END) AS september_rides,
	SUM(CASE WHEN month_of_year = 10 THEN ride_count ELSE 0 END) AS october_rides,
	SUM(CASE WHEN month_of_year = 11 THEN ride_count ELSE 0 END) AS november_rides,
	SUM(CASE WHEN month_of_year = 12 THEN ride_count ELSE 0 END) AS december_rides
FROM rides_cte

--biketype usage by membership
SELECT rideable_type,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual_riders
FROM master..cyclistic_merg
GROUP BY rideable_type


--Creating view to store data for visualization

CREATE VIEW AverageDurationByMembertype AS
SELECT member_casual, AVG(duration_in_minutes) AS average_time
FROM master..cyclistic_merg
GROUP BY member_casual

CREATE VIEW bikeTypeUsageByMembers AS
SELECT rideable_type,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual_riders
FROM master..cyclistic_merg
GROUP BY rideable_type

CREATE VIEW NumberOfRideByDayAndMonth AS
WITH rides_cte AS (
	SELECT
	DATEPART(WEEKDAY, started_at) AS day_of_week,
	DATEPART(MONTH, started_at) AS month_of_year,
	COUNT(*) AS ride_count
	FROM master..cyclistic_merg
	GROUP BY DATEPART(WEEKDAY, started_at), DATEPART(MONTH, started_at)
)
SELECT
	SUM(CASE WHEN day_of_week = 1 THEN ride_count ELSE 0 END) AS sunday_rides,
	SUM(CASE WHEN day_of_week = 2 THEN ride_count ELSE 0 END) AS monday_rides,
	SUM(CASE WHEN day_of_week = 3 THEN ride_count ELSE 0 END) AS tuesday_rides,
	SUM(CASE WHEN day_of_week = 4 THEN ride_count ELSE 0 END) AS wednesday_rides,
	SUM(CASE WHEN day_of_week = 5 THEN ride_count ELSE 0 END) AS thursday_rides,
	SUM(CASE WHEN day_of_week = 6 THEN ride_count ELSE 0 END) AS fridayday_rides,
	SUM(CASE WHEN day_of_week = 7 THEN ride_count ELSE 0 END) AS saturday_rides,
	SUM(CASE WHEN month_of_year = 1 THEN ride_count ELSE 0 END) AS january_rides,
	SUM(CASE WHEN month_of_year = 2 THEN ride_count ELSE 0 END) AS february_rides,
	SUM(CASE WHEN month_of_year = 3 THEN ride_count ELSE 0 END) AS march_rides,
	SUM(CASE WHEN month_of_year = 4 THEN ride_count ELSE 0 END) AS april_rides,
	SUM(CASE WHEN month_of_year = 5 THEN ride_count ELSE 0 END) AS may_rides,
	SUM(CASE WHEN month_of_year = 6 THEN ride_count ELSE 0 END) AS june_rides,
	SUM(CASE WHEN month_of_year = 7 THEN ride_count ELSE 0 END) AS july_rides,
	SUM(CASE WHEN month_of_year = 8 THEN ride_count ELSE 0 END) AS august_rides,
	SUM(CASE WHEN month_of_year = 9 THEN ride_count ELSE 0 END) AS september_rides,
	SUM(CASE WHEN month_of_year = 10 THEN ride_count ELSE 0 END) AS october_rides,
	SUM(CASE WHEN month_of_year = 11 THEN ride_count ELSE 0 END) AS november_rides,
	SUM(CASE WHEN month_of_year = 12 THEN ride_count ELSE 0 END) AS december_rides
FROM rides_cte

CREATE VIEW StationsByTraffic AS 
SELECT start_station_name, COUNT(start_station_name) AS start_station_count,
	   end_station_name, COUNT(end_station_name) AS end_station_count
FROM master..cyclistic_merg
WHERE start_station_name is NOT NULL AND end_station_name is NOT NULL
GROUP BY start_station_name, end_station_name
--ORDER BY start_station_count DESC, end_station_count DESC

CREATE VIEW TotalTripDurationSum AS 
SELECT member_casual, SUM(duration_in_minutes) AS total_trip_duration
FROM master..cyclistic_merg
GROUP BY member_casual


SELECT *
FROM TotalTripDurationSum
