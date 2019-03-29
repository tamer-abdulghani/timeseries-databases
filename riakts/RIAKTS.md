# Riak TS 

## Installation with Docker

To run Riak TS as a docker service: 

```
docker-compose -f riakts/docker-compose.yml up -d
```

* Access the UI using the url [http://localhost:8098/admin](http://localhost:8098/admin) 

## Design & Schema 

* Data stored together in blocks called a "quantum"
    * determine by PrimaryKey (partitionKey, localKey)
* Ring architecture 
* SQL 
* Read/Write data with client libraries
* Lots of constraints on the queries 

## Ingesting CSV file
To insert data into RiakTS, we used csv java parser and Riak Client API. [Here is an example](/riakts/ingester.java).
* Note: this code should be implemented in `Maven project` with the following dependencies:

```
   <dependencies>
        <dependency>
            <groupId>com.basho.riak</groupId>
            <artifactId>riak-client</artifactId>
            <version>2.1.1</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-simple</artifactId>
            <version>1.7.25</version>
        </dependency>
    </dependencies>
```

## Querying data
RiakTS has many restrictions when querying the database, that's to say, we should include all primary keys in the `where clause` in addition to timestamp:

```
select * 
from AIS 
where 
            timestamp > 1549302000 
        and timestamp < 1549309000 
        and mmsi = '212746000' 
        and sequence_id = '212746000#1548965106'
```