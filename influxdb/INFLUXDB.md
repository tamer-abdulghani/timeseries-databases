# InfluxDB 

## Installation with Docker 

To run Influxdb (with chronograf + telegraf) as a docker services: 

```
docker-compose -f influxdb/docker-compose.yml up -d
```

## Design & Schema 

Each point consists of 
- time
- measurement
    - e.g. ais_sequence
- tags: containing metadata
    - e.g. mmsi=999464786
    - e.g. sequence_id=999464786#9823492341
- fields (key-value)
    - e.g. longitude=551464.14, latitude=124411.14

### Why we choose mmsi as a tag, and longitude, latitude as fields? 
Because of:
* “the lower the cardinality, the more duplicated elements in a column”
* mmsi has low cardinality
* Longitude and latitude have high cardinality and cannot be chosen to be tags, that would results to large number of series ⇒ less efficient

### Can we put all attributes as fields? 
* Yes but very bad, why? 
    * Tags are indexed while fields are not indexed 
    * If we make them all fields, then it will be hard to pull up them all out from the database.

## Ingesting CSV file

Many ways: 
* Custom CSV parser and submit with curl command (working but not suffecient)
* csv-to-influx library (working with bugs and errors)
* Telegraf (try but to success)
* Logstash (try but to success)

## Querying InfluxDB
Refer to influxdb website to see the [full documentation](https://docs.influxdata.com/influxdb/v1.7/query_language/schema_exploration/)

Use docker command to access influxdb container and then `influx` to access influxdb shell CLI, :  
```
docker exec -it my-influxdb /bin/bash

root@my-influxdb:/# influx

Connected to http://localhost:8086 version 1.7.4
InfluxDB shell version: 1.7.4
Enter an InfluxQL query
> 
```

* Sample query
```
select latitude,longitude 
from AIS20190204 
where time >= '2019-02-04T19:30:00Z' and time <= '2019-02-04T20:00:00Z' 
group by mmsi limit 5
```

## Chronograf
If you have already ingested data to influxdb and you want to view it with Chronograf, you can do that by accessing UI with [http://localhost:8888](http://localhost:8888):
* Connect with host: http://my-influxdb:8086
* Navigate to Explore
 
Sample query:
```
select *
from AIS.autogen.ais_me 
where time >= '2019-02-04T19:30:00Z' and time <= '2019-02-04T20:00:00Z' and mmsi = '212746000'
group by mmsi
```

Or

```
select count(*)
from AIS.autogen.ais_me 
```