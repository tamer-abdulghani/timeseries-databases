# Imply  

## Installation with Docker 

To run Imply as a docker service: 

```
docker-compose -f imply/docker-compose.yml up -d
```

* Access the UI using the url [http://localhost:9095](http://localhost:9095) 


## Design & Schema 
* In Druid every row has a `timestamp`
    * Data partitioned by time (minutes,hours,days)
* Dimensions are fields that can be filtered or grouped by 
    * mmsi, time
* Metrics are abrogators functions (count, sum ...etc)
    * numbers, float, ... 

## Ingesting CSV file

There are two ways for ingesting CSV data to Druid: 
1. Using Imply UI, follow these actions:
     * Load data
     * Other (batch)
     * Copy/Past Json config [here is an example](/imply/conf/csv-from-parquet.json)
     * Send 
     
2. Using Shell: 
     * Access imply docker container 
     * Navigate to /opt/imply-2.8.7
     * `bin/post-index-task --file /var/lib/imply/resources/csv-from-parquet.json`

## Querying data

```
select timestamp, count(latitude)
from "aisp1-20190204"
where 
    __time >= Timestamp '2019-02-04 19:30:00'
and __time <= Timestamp '2019-02-04 20:00:00'
group by "timestamp"
```

```
select *
from "aisp1-20190204"
where
    __time >= Timestamp '2019-02-04 19:30:00'
and __time <= Timestamp '2019-02-04 20:00:00'
and mmsi='218292000'
```