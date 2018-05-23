--create database impala_flights;
--use impala_flights;

create table flight2(
Year int, Quarter int, Month int, DayofMonth int, DayOfWeek int, FlightDate timestamp, 
UniqueCarrier string, AirlineID int, Carrier string, TailNum string, FlightNum string, 
OriginAirportID int, OriginAirportSeqID int, OriginCityMarketID int, Origin string, 
OriginCityName string, OriginState string, OriginStateFips int, OriginStateName string, 
OriginWac int, DestAirportID int, DestAirportSeqID int, DestCityMarketID int, Dest string, 
DestCityName string, DestState string, DestStateFips int, DestStateName string, DestWac int, 
CRSDepTime int, DepTime int, DepDelay double, DepDelayMinutes double, DepDel15 double, 
DepartureDelayGroups int, DepTimeBlk string, TaxiOut double, WheelsOff int, WheelsOn int, 
TaxiIn double, CRSArrTime int, ArrTime int, ArrDelay double, ArrDelayMinutes double, 
ArrDel15 double, ArrivalDelayGroups int, ArrTimeBlk string, Cancelled double, 
CancellationCode string, Diverted double, CRSElapsedTime double, ActualElapsedTime double, 
AirTime double, Flights double, Distance double, DistanceGroup int, CarrierDelay double, 
WeatherDelay double, NASDelay double, SecurityDelay double, LateAircraftDelay double, 
FirstDepTime int, TotalAddGTime double, LongestAddGTime double, DivAirportLandings int, 
DivReachedDest double, DivActualElapsedTime double, DivArrDelay double, DivDistance double, 
Div1Airport string, Div1AirportID int, Div1AirportSeqID int, Div1WheelsOn int, Div1TotalGTime double, 
Div1LongestGTime double, Div1WheelsOff int, Div1TailNum string, Div2Airport string, Div2AirportID int, 
Div2AirportSeqID int, Div2WheelsOn int, Div2TotalGTime double, Div2LongestGTime double, Div2WheelsOff int, 
Div2TailNum string, Div3Airport string, Div3AirportID string, Div3AirportSeqID string, 
Div3WheelsOn string, Div3TotalGTime string, Div3LongestGTime string, Div3WheelsOff string, 
Div3TailNum string, Div4Airport string, Div4AirportID string, Div4AirportSeqID string, 
Div4WheelsOn string, Div4TotalGTime string, Div4LongestGTime string, Div4WheelsOff string, 
Div4TailNum string, Div5Airport string, Div5AirportID string, Div5AirportSeqID string, 
Div5WheelsOn string, Div5TotalGTime string, Div5LongestGTime string, Div5WheelsOff string, 
Div5TailNum string, crlf string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' --ESCAPED BY '"'
LOCATION '/user/admin/flight'
tblproperties('skip.header.line.count'='1',"quoteChar" = '"');

invalidate metadata;
--drop table flight2;

select * from flight2 limit 10;

