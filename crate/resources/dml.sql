-- CREATE statement for AIS
-- PRIMARY KEY AND DATA TYPES are very important in order to make ingestion works properly
--          * PRIMARY KEY: MUST BE UNIQUE BETWEEN ALL ROWS
--          * DATE TYPES : MUST MATCH THE DATA, FOR SIMPLICIY ==> STRING FOR MOST OF ATTRIBUTES


-- CREATE STATEMENT WITH ALL ATTRIBUTES
CREATE TABLE AIS (
                timestamp STRING,
                timestamp BIGINT,
                type_of_mobile STRING,
                mmsi STRING,
                latitude FLOAT,
                longitude FLOAT,
                navigational_status STRING,
                rot STRING,
                sog STRING,
                cog STRING,
                heading STRING,
                imo STRING,
                callsign STRING,
                name STRING,
                ship_type STRING,
                cargo_type STRING,
                width STRING,
                length STRING,
                type_of_position_fixing_device STRING,
                draught STRING,
                destination STRING,
                eta STRING,
                data_source_type STRING,
                a STRING,
                b STRING,
                c STRING,
                d STRING,
                sequence_id STRING,
                partition INT,
                PRIMARY KEY ("mmsi", "timestamp")
)
CLUSTERED BY (mmsi) INTO 10 SHARDS
PARTITIONED BY (partition)
;


-- CREATE STATEMENT WITH SOME ATTRIBUTES
create table AIS (
                    timestamp STRING,
                    long_timestamp TIMESTAMP,
                    mmsi STRING,
                    latitude FLOAT,
                    longitude FLOAT,
                    sequence_id STRING,
                    partition INT,
                    PRIMARY KEY ("sequence_id","timestamp")
);
