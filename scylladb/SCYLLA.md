# ScyllaDB 

## Installation with Docker

To run ScyllaDB as a docker service: 

```
docker-compose -f scylladb/docker-compose.yml up -d
```

## Design & Schema 

The primary key composed of two parts: ( 1 partition key and 1 or more clustering columns):
* PRIMARY KEY (mmsi, timestamp)
    * mmsi: partition key 
    * timestamp: clustering column 
    
* Note: In AIS context, we have high cardinality in these columns (mmsi, partition), which means all these columns are good candidates to be included in primary key
* partition: is a new column represent the `day` part of timestamp.
* Partition key (parition + mmsi) 

## Ingesting CSV file

* Spark:
    * Extractor: Load csv, store in parquet
    * Transformer: read parquet, transform, store in scylladb
* CQLSH

``` 
COPY ais_ks.ais_ts (..cols..) 
FROM '/etc/db/resources/ais.csv' 
WITH HEADER = TRUE AND DATETIMEFORMAT = ‘%d/%m/%Y %H:%M:%S’;
```

- Note: problem with `DATETIMEFORMAT = ‘%d/%m/%Y %H:%M:%S’` could be the `/` escaping


## Querying data

Use docker command to access scylladb container and then `cqlsh` to access CQL Shell:  

```
docker exec -it my-scylla-db /bin/bash
```

```
[root@my-scylla-db /]# cqlsh
Connected to  at my-scylla-db:9042.
[cqlsh 5.0.1 | Cassandra 3.0.8 | CQL spec 3.3.1 | Native protocol v4]
Use HELP for help.
cqlsh> 
```

Sample queries: 

```
SELECT * 
FROM ais_ks.ais_table 
WHERE 
        timestamp >= 1549303200 AND 
        timestamp <= 1549304000 AND 
        mmsi = ‘219023617’ 
LIMIT 10 
ALLOW FILTERING
```