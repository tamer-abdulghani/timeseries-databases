# CrateDB  

## Installation with Docker 

To run CrateDB as a docker service: 

```
docker-compose -f crate/docker-compose.yml up -d
```

* Access the UI using the url [http://localhost:4200](http://localhost:4200) 

## Design & Schema

Normal RDBMS Tables.

* NOTES: 
    * CREATE statement for AIS
    * PRIMARY KEY AND DATA TYPES are very important in order to make ingestion works properly
        * PRIMARY KEY: MUST BE UNIQUE BETWEEN ALL ROWS
        * DATE TYPES : MUST MATCH THE DATA, FOR SIMPLICITY ==> STRING FOR MOST OF ATTRIBUTES
  

## Querying data

1. UI: localhost:4200 ⇒ console (regular sql queries)
2. CrateDB Shell: **Crash**
    * https://crate.io/docs/clients/crash/en/latest/getting-started.html#install 
    * `curl -o crash https://cdn.crate.io/downloads/releases/crash_standalone_latest` 
    * `chmod +x crash`
    * `./crash`
    * Type your sql queries 
3. Httpie: 
    *   Install: `sudo apt-get install httpie`
    *   `sh$ http localhost:4200/_sql stmt="SELECT COUNT(*) FROM tweets"` 

## Ingesting CSV file

Before ingesting any data, make sure that tables are created in CrateDB using **crash** and sql create statements, [here is an example](/crate/resources/dml.sql)

Two primary ways to ingest data to CrateDB: 
1. From **crash** command line
    *   `COPY AIS FROM '/var/lib/crate/resources/aisp1-20190204.csv' RETURN SUMMARY;`
2. Using Java custom parser to generate script with many curl statements that do [bulk insert](https://crate.io/docs/crate/reference/en/latest/interfaces/http.html#bulk-operations) just like the below example:

```
curl -sS -H 'Content-Type: application/json' \-X POST '127.0.0.1:4200/_sql' -d@- <<- EOF
{
"stmt":
"INSERT INTO AIS (timestamp,type_of_mobile,mmsi,latitude,longitude,navigational_status,rot,sog,cog,heading,imo,callsign,name,ship_type,cargo_type,width,length,type_of_position_fixing_device,draught,destination,eta,data_source_type,a,b,c,d,timestamp,partition) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
"bulk_args": [ 
                [
                "04/02/2019 18:00:06","Class A","212746000","55.492402","9.490543","Under way using engine","86.4","0.0","272.3","240.0","8509820","P3FN8","MAUREEN S.","Cargo","","12","88","GPS","5.1","DK KOL","02/02/2019 07:00:00","AIS","73","15","11","1","1549303206","212746000#1548965106","20190204"
                ],
                [
                "04/02/2019 18:10:06","Class A","212746001","55.492402","9.490543","Under way using engine","86.4","0.0","272.3","240.0","8509820","P3FN8","MAUREEN S.","Cargo","","12","88","GPS","5.1","DK KOL","02/02/2019 07:00:00","AIS","73","15","11","1","1549303206","212746001#1548965106","20190204"
                ]
             ]
}
EOF
``` 

## Sample queries

```
SELECT sequence_id, count(latitude) 
FROM ais3 
WHERE timestamp >= '04/02/2019 18:30:00' and timestamp <= '04/02/2019 19:30:00' 
GROUP BY "sequence_id" 
LIMIT 100;
```

```
SELECT * 
FROM ais3 
WHERE timestamp >= '04/02/2019 18:30:00' and timestamp <= '04/02/2019 19:30:00' and mmsi = '211212470' 
LIMIT 100;
```

