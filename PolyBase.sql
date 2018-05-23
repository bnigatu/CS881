
--CREATE DATABASE CS881;
--GO

--USE CS881;
--GO
/*
--DROP TABLE flight
CREATE TABLE flight  (
	Year	INT,
	Quarter	INT,
	Month	INT,
	DayofMonth	INT,
	DayOfWeek	INT,
	FlightDate	DATETIME, 
	UniqueCarrier	VARCHAR(100),
	AirlineID	VARCHAR(100) ,--INT,
	Carrier	VARCHAR(100),
	TailNum	VARCHAR(100),
	FlightNum	VARCHAR(100) ,--INT,
	OriginAirportID	VARCHAR(100) ,--INT,
	OriginAirportSeqID	VARCHAR(100) ,--INT,
	OriginCityMarketID	VARCHAR(100) ,--INT,
	Origin	VARCHAR(100),
	OriginCityName	VARCHAR(100),
	OriginState	VARCHAR(100),
	OriginStateFips	VARCHAR(100) ,--INT,
	OriginStateName	VARCHAR(100),
	OriginWac	VARCHAR(100) ,--INT,
	DestAirportID	VARCHAR(100) ,--INT,
	DestAirportSeqID	VARCHAR(100) ,--INT,
	DestCityMarketID	VARCHAR(100) ,--INT,
	Dest	VARCHAR(100),
	DestCityName	VARCHAR(100),
	DestState	VARCHAR(100),
	DestStateFips	VARCHAR(100) ,--INT,
	DestStateName	VARCHAR(100),
	DestWac	VARCHAR(100) ,--INT,
	CRSDepTime	VARCHAR(100) ,--INT,
	DepTime	VARCHAR(100) ,--INT,
	DepDelay	VARCHAR(100) ,--INT,
	DepDelayMinutes	VARCHAR(100) ,--INT,
	DepDel15	VARCHAR(100) ,--INT,
	DepartureDelayGroups	VARCHAR(100) ,--INT,
	DepTimeBlk	VARCHAR(100),
	TaxiOut	VARCHAR(100) ,--INT,
	WheelsOff	VARCHAR(100) ,--INT,
	WheelsOn	VARCHAR(100) ,--INT,
	TaxiIn	VARCHAR(100) ,--INT,
	CRSArrTime	VARCHAR(100) ,--INT,
	ArrTime	VARCHAR(100) ,--INT,
	ArrDelay	VARCHAR(100) ,--INT,
	ArrDelayMinutes	VARCHAR(100) ,--INT,
	ArrDel15	VARCHAR(100) ,--INT,
	ArrivalDelayGroups	VARCHAR(100) ,--INT,
	ArrTimeBlk	VARCHAR(100),
	Cancelled	VARCHAR(100) ,--INT,
	CancellationCode	VARCHAR(100),
	Diverted	VARCHAR(100) ,--INT,
	CRSElapsedTime	VARCHAR(100) ,--INT,
	ActualElapsedTime	VARCHAR(100) ,--INT,
	AirTime	VARCHAR(100) ,--INT,
	Flights	VARCHAR(100) ,--INT,
	Distance	VARCHAR(100) ,--INT,
	DistanceGroup	VARCHAR(100) ,--INT,
	CarrierDelay	VARCHAR(100),
	WeatherDelay	VARCHAR(100),
	NASDelay	VARCHAR(100),
	SecurityDelay	VARCHAR(100),
	LateAircraftDelay	VARCHAR(100),
	FirstDepTime	VARCHAR(100),
	TotalAddGTime	VARCHAR(100),
	LongestAddGTime	VARCHAR(100),
	DivAirportLandings	VARCHAR(100) ,--INT,
	DivReachedDest	VARCHAR(100),
	DivActualElapsedTime	VARCHAR(100),
	DivArrDelay	VARCHAR(100),
	DivDistance	VARCHAR(100),
	Div1Airport	VARCHAR(100),
	Div1AirportID	VARCHAR(100),
	Div1AirportSeqID	VARCHAR(100),
	Div1WheelsOn	VARCHAR(100),
	Div1TotalGTime	VARCHAR(100),
	Div1LongestGTime	VARCHAR(100),
	Div1WheelsOff	VARCHAR(100),
	Div1TailNum	VARCHAR(100),
	Div2Airport	VARCHAR(100),
	Div2AirportID	VARCHAR(100),
	Div2AirportSeqID	VARCHAR(100),
	Div2WheelsOn	VARCHAR(100),
	Div2TotalGTime	VARCHAR(100),
	Div2LongestGTime	VARCHAR(100),
	Div2WheelsOff	VARCHAR(100),
	Div2TailNum	VARCHAR(100),
	Div3Airport	VARCHAR(100),
	Div3AirportID	VARCHAR(100),
	Div3AirportSeqID	VARCHAR(100),
	Div3WheelsOn	VARCHAR(100),
	Div3TotalGTime	VARCHAR(100),
	Div3LongestGTime	VARCHAR(100),
	Div3WheelsOff	VARCHAR(100),
	Div3TailNum	VARCHAR(100),
	Div4Airport	VARCHAR(100),
	Div4AirportID	VARCHAR(100),
	Div4AirportSeqID	VARCHAR(100),
	Div4WheelsOn	VARCHAR(100),
	Div4TotalGTime	VARCHAR(100),
	Div4LongestGTime	VARCHAR(100),
	Div4WheelsOff	VARCHAR(100),
	Div4TailNum	VARCHAR(100),
	Div5Airport	VARCHAR(100),
	Div5AirportID	VARCHAR(100),
	Div5AirportSeqID	VARCHAR(100),
	Div5WheelsOn	VARCHAR(100),
	Div5TotalGTime	VARCHAR(100),
	Div5LongestGTime	VARCHAR(100),
	Div5WheelsOff	VARCHAR(100),
	Div5TailNum	VARCHAR(100)
)
GO


drop table airline;

CREATE TABLE [dbo].airline(
	[Code] [varchar](100) NULL,
	[Description] [varchar](255) NULL
) ON [PRIMARY]
GO


drop table airport;

CREATE TABLE [dbo].airport(
	[Code] [varchar](100) NULL,
	[Description] [varchar](255) NULL
) ON [PRIMARY]
GO

update flight set CarrierDelay=null
where CarrierDelay =''

update flight set SecurityDelay=null
where SecurityDelay =''

update flight set WeatherDelay=null
where WeatherDelay =''

update flight set LateAircraftDelay=null
where LateAircraftDelay =''

update flight set NASDelay=null
where NASDelay =''

update flight set arrdelayminutes=null
where arrdelayminutes =''

update flight set TotalAddGTime=null
where TotalAddGTime =''

update flight set DepDelay=null
where DepDelay =''

update flight set ArrDelay=null
where ArrDelay =''
go


alter table flight alter column 
         CarrierDelay  decimal;
alter table flight alter column 
		 SecurityDelay  decimal;
alter table flight alter column 
		 WeatherDelay  decimal;
alter table flight alter column 
		 LateAircraftDelay  decimal;
alter table flight alter column 
		 NASDelay decimal;
alter table flight alter column 
		 arrdelayminutes decimal
alter table flight alter column 
		 TotalAddGTime decimal
alter table flight alter column 
		 DepDelay decimal
alter table flight alter column 
		 ArrDelay decimal
		 
*/




--total flight in the past 10 years.
select count(*) from flight;
--flights per year
SELECT YEAR, count(*) cnt
FROM flight WITH(NOLOCK) 
GROUP BY YEAR;

--top three busiest airports per year
with cte as (
SELECT f.YEAR,a.Description airport, count(*) num_flight, rank() over(partition by  f.YEAR order by count(*) desc) ord
FROM flight f WITH(NOLOCK) 
LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
GROUP BY YEAR,a.Description
)
select year, airport, num_flight
from cte
where ord<=3
order by year,ord

--top three airlines per year
WITH cte
AS (
	SELECT f.YEAR
		,a.Description airline
		,count(*) num_flight
		,rank() OVER (
			PARTITION BY f.YEAR ORDER BY count(*) DESC
			) ord
	FROM flight f WITH (NOLOCK)
	LEFT JOIN airline a WITH (NOLOCK) ON f.AirlineID = a.code
	GROUP BY YEAR
		,a.Description
	)
SELECT year
	,airline
	,num_flight
FROM cte
WHERE ord <= 3
ORDER BY year
	,ord;


--top three airport per year
;WITH cte
AS (
	SELECT f.YEAR
		,a.Description airport
		,count(*) num_flight
		,rank() OVER (
			PARTITION BY f.YEAR ORDER BY count(*) DESC
			) ord
	FROM flight f WITH (NOLOCK)
	LEFT JOIN airport a WITH (NOLOCK) ON f.OriginAirportID = a.code
	GROUP BY YEAR
		,a.Description
	)
SELECT year
	,airport
	,num_flight
FROM cte
WHERE ord <= 3
ORDER BY year
	,ord;


--a list of all multi-leg flights
SELECT COUNT(uniqueid) AS cnt, uniqueid 
FROM(
	SELECT concat(concat(flightnum,flightdate),UniqueCarrier) AS uniqueid 
	FROM flight	
	GROUP BY concat(concat(flightnum,flightdate),UniqueCarrier) 
	)a	
group by uniqueid
having COUNT(uniqueid) > 1




--mid air delay to see if there is aircraft is slow or has problem
with cte as (
	SELECT year, airline,sum(MidairDelay) total_midair_dealy_minutes,count(MidairDelay) total_midair_dealy_flights
	FROM (
		SELECT f.year, a.Description airline, cast(arrdelayminutes as decimal) as arrdelayminutes
			,isnull(f.CarrierDelay ,0) + 
			 isnull(f.SecurityDelay ,0) + 
			 isnull(f.WeatherDelay ,0) + 
			 isnull(f.LateAircraftDelay ,0) + 
			 isnull(f.NASDelay ,0) AS origin_delay,
			 arrdelayminutes - (isnull(f.CarrierDelay ,0) + 
			 isnull(f.SecurityDelay ,0) + 
			 isnull(f.WeatherDelay ,0) + 
			 isnull(f.LateAircraftDelay ,0) + 
			 isnull(f.NASDelay ,0)) MidairDelay 		
		FROM flight f
		LEFT JOIN airline a with(nolock) on f.AirlineID = a.code
		WHERE arrdelayminutes - (isnull(f.CarrierDelay ,0) + 
			 isnull(f.SecurityDelay ,0) + 
			 isnull(f.WeatherDelay ,0) + 
			 isnull(f.LateAircraftDelay ,0) + 
			 isnull(f.NASDelay ,0)) > 0
		) as a
	WHERE  MidairDelay>0
	group by year, airline
)
, cte2 as (
select year, airline, total_midair_dealy_minutes,total_midair_dealy_flights,
 rank() over(partition by year order by total_midair_dealy_flights desc) rd
 from cte
 )
 select year,airline, total_midair_dealy_minutes,total_midair_dealy_flights
 from cte2
 where rd<4
order by 1,3 desc;

--% of mid air delay per total flights per airline
SELECT a.year, a.airline,sum(arrdelayminutes) total_dealy_minutes, count(b.total_flights) total_flights_delayed, (count(b.total_flights)*100.0/b.total_flights) percentage_flights
FROM (
	SELECT f.year, a.Description airline, cast(arrdelayminutes as decimal) as arrdelayminutes
		,isnull(f.CarrierDelay ,0) + 
		 isnull(f.SecurityDelay ,0) + 
		 isnull(f.WeatherDelay ,0) + 
		 isnull(f.LateAircraftDelay ,0) + 
		 isnull(f.NASDelay ,0) AS origin_delay
	FROM flight f
	LEFT JOIN airline a with(nolock) on f.AirlineID = a.code
	WHERE cast(arrdelayminutes as decimal) > 0
	) as a
	join 
	(
	SELECT f.year, a.Description airline, count(1) as total_flights
	FROM flight f	
	LEFT JOIN airline a with(nolock) on f.AirlineID = a.code
	group by f.year, a.Description
	) as b on a.year = b.year and a.airline = b.airline
WHERE  arrdelayminutes  > a.origin_delay
group by a.year, a.airline,b.total_flights
order by 1,5 desc

--% Flights delatyed after boarded or Ground Time Away from Gate for Gate Return or Cancelled Flight
SELECT a.year, a.airline,sum(TotalAddGTime) Total_delay_afterboard_minutes
FROM (
		SELECT f.year, a.Description airline, TotalAddGTime
		FROM flight f
		LEFT JOIN airline a with(nolock) on f.AirlineID = a.code
		WHERE cast(TotalAddGTime as decimal) > 0
	) as a
WHERE  TotalAddGTime>0
group by a.year, a.airline
order by 1,3 desc

--Longers departure delay per airport per year:
WITH cte AS (
	SELECT f.YEAR,a.Description airport, sum(DepDelay) DepDelay_total, rank() over(PARTITION by year ORDER by sum(DepDelay) asc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	GROUP BY year,a.Description
)
SELECT year,airport,DepDelay_total
FROM cte
WHERE RD<4
ORDER BY 1,3 asc

--This data is questionable some airports has a large negative delay
WITH cte AS (
	SELECT f.YEAR,a.Description airport, sum(DepDelay) DepDelay_total, rank() over(PARTITION by year ORDER by sum(DepDelay) asc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	GROUP BY year,a.Description
)
SELECT year,airport,DepDelay_total
FROM cte
WHERE RD<4
ORDER BY 1,3 DESC

--Average departure delay pery year per airport
WITH cte AS (
	SELECT f.YEAR,a.Description airport, avg(DepDelay) avg_DepDelay_total, rank() over(PARTITION by year ORDER by avg(DepDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	GROUP BY year,a.Description
)
SELECT year,airport,avg_DepDelay_total
FROM cte
WHERE RD<4
ORDER BY 1,3 DESC

--Average arrival delay per ear per airport
WITH cte AS (
	SELECT f.YEAR,a.Description airport, avg(ArrDelay) avg_ArrDelay, rank() over(PARTITION by year ORDER by avg(ArrDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.DestAirportID = a.code
	GROUP BY year,a.Description
)
SELECT year,airport,avg_ArrDelay
FROM cte
WHERE RD<4
ORDER BY 1,3 DESC

select * from flight
--A month of a year that has the most total departure dealy 
WITH cte AS (
	SELECT f.YEAR,f.month, --a.Description airport, 
	count(DepDelay) DepDelay_total, rank() over(PARTITION by year,month ORDER by count(DepDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	--LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	--where DepDelay>0
	GROUP BY f.year,f.month--,a.Description
)
SELECT year,month,avg_DepDelay_total
FROM cte
WHERE RD<4
ORDER BY 1,2 DESC

--Airports
WITH cte AS (
	SELECT f.OriginState,--f.OriginCityName, --a.Description airport, 
	count(DepDelay) TotalDelay, rank() over(PARTITION by OriginState/*,OriginCityName*/ ORDER by count(DepDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	where DepDelay>0
	GROUP BY f.OriginState--,f.OriginCityName--,a.Description
)
SELECT OriginState,-- OriginCityName,
	   TotalDelay
FROM cte
WHERE RD<4
ORDER BY 1,2 DESC

--A month of a year that has the most total arrival dealy
WITH cte AS (
	SELECT f.YEAR,f.month, --a.Description airport, 
	count(ArrDelay) avg_ArrDelay_total, rank() over(PARTITION by year ORDER by count(ArrDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	where ArrDelay>0
	GROUP BY f.year,f.month--,a.Description
)
SELECT year,month,avg_ArrDelay_total
FROM cte
WHERE RD<4
ORDER BY 1,2 DESC


--A month of a year that has the most total CarrierDelay dealy 
WITH cte AS (
	SELECT f.YEAR,f.month, --a.Description airport, 
	count(CarrierDelay) avg_CarrierDelay_total, rank() over(PARTITION by year ORDER by count(CarrierDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	where CarrierDelay>0
	GROUP BY f.year,f.month--,a.Description
)
SELECT year,month,avg_CarrierDelay_total
FROM cte
WHERE RD<4
ORDER BY 1,2 DESC

--A month of a year that has the most total SecurityDelay dealy 
WITH cte AS (
	SELECT f.YEAR,f.month, --a.Description airport, 
	count(SecurityDelay) avg_SecurityDelay_total, rank() over(PARTITION by year ORDER by count(CarrierDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	where SecurityDelay>0
	GROUP BY f.year,f.month--,a.Description
)
SELECT year,month,avg_SecurityDelay_total
FROM cte
WHERE RD<4
ORDER BY 1,2 DESC

--A month of a year that has the most total SecurityDelay dealy 

SELECT airport,avg_SecurityDelay_total,'Security Delay' reason
FROM (
	SELECT a.Description airport, 
	count(SecurityDelay) avg_SecurityDelay_total, rank() over( ORDER by count(CarrierDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	where SecurityDelay>0
	GROUP BY a.Description--,a.Description
)cte
WHERE RD<4
--ORDER BY 1,2 DESC
union all
--A month of a year that has the most total WeatherDelay dealy 

SELECT Airport,TotalDelay,'Weather Delay' Reason
FROM (
	SELECT a.Description airport, 
	count(WeatherDelay) TotalDelay, rank() over(ORDER by count(WeatherDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	where WeatherDelay>0
	GROUP BY a.Description--,f.month--,a.Description
) cte
WHERE RD<4
--ORDER BY 1,2 DESC
union all
--A month of a year that has the most total LateAircraftDelay dealy 

SELECT airport,avg_LateAircraftDelay_total,'Late Aircraft Delay' reason
FROM (
	SELECT a.Description airport, 
	count(LateAircraftDelay) avg_LateAircraftDelay_total, rank() over( ORDER by count(LateAircraftDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	where LateAircraftDelay>0
	GROUP BY a.Description--,f.month--,a.Description
)cte
WHERE RD<4
--ORDER BY 1,2 DESC
union all

--An hour of a day that has the most total departure dealy 

SELECT  airport,DepDelay_total,'CRS Deplay' reason
FROM (
	SELECT a.Description airport, 
	count(DepDelay) DepDelay_total, 
	ROW_NUMBER() over( ORDER by count(DepDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	WHERE CRSDepTime>0
	GROUP BY a.Description--,a.Description
) as cte
WHERE RD<4
--ORDER BY 1,2 DESC

union all

--An hour of a day that has the most total departure dealy 

SELECT airport,DepDelay_total,'NAS Delay' reason
FROM (
	SELECT a.Description airport, 
	count(DepDelay) DepDelay_total, 
	ROW_NUMBER() over( ORDER by count(DepDelay) desc) rd
	FROM flight f WITH(NOLOCK) 
	LEFT JOIN airport a with(nolock) on f.OriginAirportID = a.code
	WHERE NASDelay>0
	GROUP BY a.Description--,a.Description
) as cte
WHERE RD<4
ORDER BY 3,2 DESC



















 
